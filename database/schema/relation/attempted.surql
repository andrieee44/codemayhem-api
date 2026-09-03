DEFINE TABLE attempted SCHEMAFULL TYPE RELATION
  IN users OUT problems_variants ENFORCED
  PERMISSIONS
    FOR create WHERE !!$auth
    FOR select, update, delete WHERE $auth.id = in.id;

DEFINE FIELD id         ON attempted TYPE uuid;
DEFINE FIELD attempt    ON attempted TYPE string;
DEFINE FIELD created_at ON attempted TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD updated_at ON attempted TYPE datetime VALUE time::now();
