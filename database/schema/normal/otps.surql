DEFINE TABLE otps SCHEMAFULL TYPE NORMAL
  PERMISSIONS
    FOR create, select, update, delete NONE;

DEFINE FIELD id         ON otps TYPE uuid;
DEFINE FIELD updated_at ON otps TYPE datetime VALUE time::now();

DEFINE FIELD email ON otps TYPE string
  ASSERT string::is_email($value)
    AND string::split($value, "@")[1] = $EMAIL_DOMAIN
  VALUE string::lowercase(string::trim($value));

DEFINE FIELD pass ON otps TYPE string
  ASSERT !!$value
  VALUE crypto::argon2::generate($value);

DEFINE INDEX uq_otps_email ON otps FIELDS email UNIQUE;
