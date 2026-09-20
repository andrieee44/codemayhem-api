DEFINE FUNCTION fn::get_otp($email: string, $pass: string) -> option<object> {
  RETURN (
    SELECT * FROM ONLY otps
    WHERE crypto::argon2::compare(pass, $pass)
      AND email = $email
      AND updated_at + $OTP_TTL > time::now()
  )
} PERMISSIONS NONE;
