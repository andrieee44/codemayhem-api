DEFINE TABLE users SCHEMAFULL TYPE NORMAL
  PERMISSIONS
    FOR create NONE
    FOR select, update, delete WHERE $auth.id = id;

DEFINE FIELD id         ON users TYPE uuid;
DEFINE FIELD created_at ON users TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD updated_at ON users TYPE datetime VALUE time::now();
DEFINE FIELD username   ON users TYPE string   ASSERT !!$value;

DEFINE FIELD email ON users TYPE string
  ASSERT string::is_email($value)
    AND string::split($value, "@")[1] = $EMAIL_DOMAIN
  VALUE string::lowercase(string::trim($value))
  PERMISSIONS
    FOR update NONE;

DEFINE FIELD pass ON users TYPE string
  ASSERT !!$value
  VALUE crypto::argon2::generate($value)
  PERMISSIONS
    FOR select, update NONE;

DEFINE INDEX uq_users_email    ON users FIELDS email    UNIQUE;
DEFINE INDEX uq_users_username ON users FIELDS username UNIQUE;

DEFINE ACCESS users ON DATABASE TYPE RECORD
  SIGNIN (
    SELECT * FROM users
    WHERE email = $email
      AND crypto::argon2::compare(pass, $pass)
  )
  DURATION FOR TOKEN 12h, FOR SESSION 12h;
