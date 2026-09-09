DEFINE API "/email"
  FOR patch
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE !!$auth
  THEN {
    LET $otpOld = fn::get_otp($auth.email, $request.body.otpOld);
    LET $otpNew = fn::get_otp($request.body.email, $request.body.otpNew);

    IF $otpOld = NONE OR $otpNew = NONE {
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
    DELETE [ $otpOld, $otpNew ];

    RETURN {
      status: 204,
      body: "No Content"
    };
  };
