DEFINE TABLE liked SCHEMAFULL TYPE RELATION
  IN users OUT problems ENFORCED
  PERMISSIONS
    FOR create, select WHERE !!$auth
    FOR update, delete WHERE $auth.id = in.id;

DEFINE FIELD id ON liked TYPE uuid;

DEFINE INDEX uq_liked_in_out ON liked FIELDS in, out UNIQUE;
