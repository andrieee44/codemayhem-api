DEFINE API "/otp"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  THEN {
    LET $email = string::lowercase(string::trim($request.body.email));

    IF !string::is_email($email)
      OR string::split($email, "@")[1] != $EMAIL_DOMAIN
    {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    LET $otp = SELECT * FROM otps WHERE email = $email;

    IF !!$otp AND $otp[0].updated_at + $OTP_TTL > time::now() {
      RETURN {
        status: 429,
        headers: { "Retry-After": <string>($otp[0].updated_at + $OTP_TTL) },
        body: "Too Many Requests"
      };
    };

    LET $retry_at = fn::retry_at("POST /otp", 200, 1d);

    IF !!$retry_at {
      RETURN {
        status: 429,
        headers: { "Retry-After": <string>$retry_at },
        body: "Too Many Requests"
      };
    };

    LET $pass = <string>rand::int(100000, 999999);

    http::post($MAILMS_URL + "/mail", {
      user: $MAILMS_USER,
      pass: $MAILMS_PASS,
      host: $MAILMS_HOST,
      port: $MAILMS_PORT,
      from: $MAILMS_USER,
      to: [ $email ],
      subject: "CodeMayhem OTP",
      headers: [ { key: "Content-Type", value: "text/html; charset=UTF=8" } ],
      body: "<p>Your OTP is " + $pass + "</p>"
    });

    UPSERT otps
      SET email = $email,
        pass = $pass
      WHERE email = $email;

    RETURN {
      status: 201,
      body: "Created"
    };
  };
