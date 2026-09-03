DEFINE API "/profile/:id"
  FOR get
  MIDDLEWARE api::res::body()
  THEN {
    LET $user = SELECT * FROM ONLY type::record(
      "users", type::uuid($request.params.id)
    );

    IF !$user {
      RETURN {
        status: 404,
        body: { error: "Not found" }
      };
    };

    RETURN {
      status: 200,
      body: {
        created_at: $user.created_at,
        updated_at: $user.updated_at,
        username:   $user.username,
      }
    };
  };
