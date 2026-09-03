DEFINE TABLE liked SCHEMAFULL TYPE RELATION
  IN users OUT problems ENFORCED
  PERMISSIONS
    FOR create, select WHERE !!$auth
    FOR update, delete WHERE $auth.id = in.id;

DEFINE FIELD id         ON liked TYPE uuid;
DEFINE FIELD created_at ON liked TYPE datetime DEFAULT time::now() READONLY;
