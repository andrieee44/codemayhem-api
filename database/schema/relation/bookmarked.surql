DEFINE TABLE bookmarked SCHEMAFULL TYPE RELATION
  IN users OUT problems ENFORCED
  PERMISSIONS
    FOR create WHERE !!$auth
    FOR select, update, delete WHERE $auth.id = in.id;

DEFINE FIELD id ON bookmarked TYPE uuid;

DEFINE INDEX uq_bookmarked_in_out ON bookmarked FIELDS in, out UNIQUE;
