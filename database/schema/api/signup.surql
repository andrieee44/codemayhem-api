DEFINE API "/signup"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS WHERE $auth = NONE
  THEN {
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

    LET $otp = SELECT * FROM otps
      WHERE crypto::argon2::compare(pass, $request.body.otp)
        AND email = $request.body.email
        AND updated_at + $OTP_TTL > time::now();

    IF $otp[0] = NONE {
      RETURN {
        status: 400,
        body: "Bad Request"
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
