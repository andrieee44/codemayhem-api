DEFINE TABLE bookmarked SCHEMAFULL TYPE RELATION
  IN users OUT problems ENFORCED
  PERMISSIONS
    FOR create WHERE !!$auth
    FOR select, update, delete WHERE $auth.id = in.id;

DEFINE FIELD id ON bookmarked TYPE uuid;

DEFINE FIELD created_at ON bookmarked TYPE datetime
  DEFAULT time::now()
  READONLY;
