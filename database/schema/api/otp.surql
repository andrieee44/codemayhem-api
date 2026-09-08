DEFINE API "/otp"
  FOR post
  MIDDLEWARE
    api::req::body(),
    api::res::body()
  PERMISSIONS FULL
  THEN {
    LET $email = string::lowercase(string::trim($request.body.email));

    IF (
      !string::is_email($email)
        OR string::split($email, "@")[1] != $EMAIL_DOMAIN
    ) {
      RETURN {
        status: 400,
        body: "Bad Request"
      };
    };

    LET $otp = (SELECT * FROM otps WHERE email = $email)[0];

    IF !!$otp AND $otp.updated_at + $OTP_TTL > time::now() {
      RETURN {
        status: 429,
        headers: { "Retry-After": <string>($otp.updated_at + $OTP_TTL) },
        body: "Too Many Requests"
      };
    };

    LET $retry_at = fn::retry_at("POST /otp", $OTP_MAX_COUNT, $OTP_WINDOW);

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
      subject: "Your CodeMayhem OTP is ready",
      headers: [ { key: "Content-Type", value: "text/html; charset=UTF=8" } ],
      body: "
        <p>Hi,</p>
        <p>
          We received a request that requires verification of your CodeMayhem
          account.
        </p>
        <p>Your one-time verification code is:</p>
        <h2 style=\"letter-spacing: 4px;\">" + $pass + "</h2>
        <p>
          This code will expire in <strong>" + <string>$OTP_TTL + "</strong>.
          For your security, please do not share this code with anyone.
        </p>
        <p>
          If you did not request this code, you can safely ignore this email.
          No action will be taken using this code without your authorization.
        </p>
        <p>Thanks,<br> The CodeMayhem Team</p>
      "
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
