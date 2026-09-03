DEFINE TABLE solved SCHEMAFULL TYPE RELATION
  IN users OUT problems_variants ENFORCED
  PERMISSIONS
    FOR create NONE
    FOR select WHERE !!$auth AND is_public
    FOR update, delete WHERE $auth.id = in.id;

DEFINE FIELD id         ON solved TYPE uuid;
DEFINE FIELD created_at ON solved TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD is_public  ON solved TYPE bool     DEFAULT false;
DEFINE FIELD solution   ON solved TYPE string   ASSERT !!$value READONLY;
