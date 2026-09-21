DEFINE TABLE attempted SCHEMAFULL TYPE RELATION
  IN users OUT problems ENFORCED
  PERMISSIONS
    FOR create, select, update, delete WHERE $auth.id = in.id;

DEFINE FIELD id         ON attempted TYPE uuid;
DEFINE FIELD solution   ON attempted TYPE string;
DEFINE FIELD created_at ON attempted TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD updated_at ON attempted TYPE datetime VALUE time::now();

DEFINE INDEX uq_attempted_in_out ON attempted FIELDS in, out UNIQUE;
