DEFINE API "/signup"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE $auth = NONE
  THEN {
    LET $otp = fn::get_otp($request.body.email, $request.body.otp);

    IF (
      $otp = NONE
        OR $request.body.email = NONE
        OR $request.body.otp = NONE
        OR $request.body.pass = NONE
        OR $request.body.username = NONE
    ) {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    IF !!(
      SELECT * FROM users
      WHERE email = $request.body.email
        OR username = $request.body.username
    ) {
      RETURN {
        status: 409,
        body: "Conflict"
      };
    };

    CREATE users SET
      email = $request.body.email,
      pass = $request.body.pass,
      username = $request.body.username;

    DELETE $otp;

    RETURN {
      status: 201,
      body: "Created"
    };
  };
