DEFINE TABLE problems SCHEMAFULL TYPE NORMAL
  PERMISSIONS
    FOR create, select WHERE !!$auth
    FOR update, delete WHERE $auth.id = author;

DEFINE FIELD id         ON problems TYPE uuid;
DEFINE FIELD created_at ON problems TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD title      ON problems TYPE string   ASSERT !!$value;
DEFINE FIELD updated_at ON problems TYPE datetime VALUE time::now();

DEFINE FIELD author ON problems
  TYPE option<record<users>> REFERENCE ON DELETE UNSET
  VALUE $auth.id;

DEFINE FIELD difficulty ON problems
  TYPE "Easy" | "Medium" | "Hard"
  ASSERT !!$value;

DEFINE INDEX uq_problems_title ON problems FIELDS title UNIQUE;
