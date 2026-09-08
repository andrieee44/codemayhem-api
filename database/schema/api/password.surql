DEFINE API "/password"
  FOR patch
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE !!$auth
  THEN {
    LET $otp = fn::get_otp($auth.email, $request.body.otp);

    IF $otp = NONE OR $request.body.pass = NONE {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    UPDATE $auth MERGE { pass: $request.body.pass };
    DELETE $otp;

    RETURN {
      status: 204,
      body: "No Content"
    };
  };
