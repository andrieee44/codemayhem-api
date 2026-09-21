DEFINE API "/problem"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE !!$auth
  THEN {
    IF (
      $request.body.body = NONE
        OR $request.body.boilerplate = NONE
        OR $request.body.title = NONE
        OR $request.body.difficulty = NONE
        OR $request.body.harness = NONE
        OR $request.body.language = NONE
        OR $request.body.solution = NONE
    ) {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    IF !!(
      SELECT * FROM problems
      WHERE title = $request.body.title
        AND language = $request.body.language
    ) {
      RETURN {
        status: 409,
        body: "Conflict"
      };
    };

    LET $result: object = fn::solve_problem(
      $request.body.harness,
      $request.body.language,
      $request.body.solution
    );

    IF $result.status != 0 {
      RETURN {
        status: 400,
        body: $result
      };
    };

    LET $problem: object = CREATE ONLY problems SET
      body = $request.body.body,
      boilerplate = $request.body.boilerplate,
      title = $request.body.title,
      author = $auth.id,
      difficulty = $request.body.difficulty,
      harness = $request.body.harness,
      language = $request.body.language,
      solution = $request.body.solution;

    RETURN {
      status: 201,
      body: { id: $problem.id }
    };
  };

DEFINE API "/problem/:id"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE !!$auth
  THEN {
    LET $problem: option<object> = SELECT * FROM ONLY type::record(
      "problems",
      type::uuid($request.params.id)
    );

    IF $problem = NONE OR $request.body.solution = NONE {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    IF !!(
      SELECT * FROM ONLY solved
      WHERE in = $auth.id AND out = $problem.id
    ) {
      RETURN {
        status: 409,
        body: "Conflict"
      };
    };

    LET $expected: object = fn::solve_problem(
      $problem.harness,
      $problem.language,
      $problem.solution
    );

    IF $expected.status != 0 {
      RETURN {
        status: 500,
        body: "Internal Server Error",
      };
    };

    LET $got: object = fn::solve_problem(
      $problem.harness,
      $problem.language,
      $request.body.solution
    );

    IF $expected != $got {
      RETURN {
        status: 400,
        body: {
          expected: $expected,
          got: $got
        },
      };
    };

    LET $solved: object = RELATE ONLY $auth->solved->$problem
      SET problem_hash = $problem.problem_hash,
        solution = $request.body.solution;

    RETURN {
      status: 201,
      body: { id: $solved.id }
    };
  }

  FOR patch
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE !!$auth
  THEN {
    LET $problem: option<object> = SELECT * FROM ONLY type::record(
      "problems",
      type::uuid($request.params.id)
    ) WHERE author = $auth.id;

    IF (
      $problem = NONE
        OR $request.body.harness = NONE
        OR $request.body.solution = NONE
    ) {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    LET $result: object = fn::solve_problem(
      $request.body.harness,
      $problem.language,
      $request.body.solution
    );

    IF $result.status != 0 {
      RETURN {
        status: 400,
        body: $result
      };
    };

    UPDATE $problem MERGE {
      harness: $request.body.harness,
      solution: $request.body.solution
    };

    RETURN {
      status: 204,
      body: "No Content"
    };
  };
