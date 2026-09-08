DEFINE API "/forgot-password"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE $auth = NONE
  THEN {
    LET $otp = fn::get_otp($request.body.email, $request.body.otp);

    IF $otp = NONE OR $request.body.pass = NONE {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    UPDATE users MERGE { pass: $request.body.pass }
      WHERE email = $request.body.email;

    DELETE $otp;

    RETURN {
      status: 204,
      body: "No Content"
    };
  };
