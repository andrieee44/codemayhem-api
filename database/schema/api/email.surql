DEFINE API "/email"
  FOR patch
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE !!$auth
  THEN {
    LET $otp = fn::get_otp($auth.email, $request.body.otp);

    IF $otp = NONE OR $request.body.email = NONE {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    IF !!(SELECT * FROM users WHERE email = $request.body.email) {
      RETURN {
        status: 409,
        body: "Conflict"
      };
    };

    UPDATE $auth MERGE { email: $request.body.email };
    DELETE $otp;

    RETURN {
      status: 204,
      body: "No Content"
    };
  };
