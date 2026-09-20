DEFINE TABLE problems SCHEMAFULL TYPE NORMAL
  PERMISSIONS
    FOR create NONE
    FOR select WHERE !!$auth
    FOR update, delete WHERE $auth.id = author;

DEFINE FIELD id          ON problems TYPE uuid;
DEFINE FIELD body        ON problems TYPE string   ASSERT !!$value;
DEFINE FIELD boilerplate ON problems TYPE string   ASSERT !!$value;
DEFINE FIELD created_at  ON problems TYPE datetime DEFAULT time::now() READONLY;
DEFINE FIELD difficulty  ON problems TYPE "Easy" | "Medium" | "Hard";
DEFINE FIELD title       ON problems TYPE string   ASSERT !!$value;
DEFINE FIELD updated_at  ON problems TYPE datetime VALUE time::now();

DEFINE FIELD author ON problems
  TYPE option<record<users>> REFERENCE ON DELETE UNSET
  VALUE $auth.id;

DEFINE FIELD harness ON problems TYPE string
  ASSERT !!$value
  PERMISSIONS
    FOR select WHERE $auth.id = author
    FOR update NONE;

DEFINE FIELD language ON problems TYPE "C" | "Java" | "SQLite"
  PERMISSIONS
    FOR update NONE;

DEFINE FIELD problem_hash ON problems TYPE string
  VALUE crypto::blake3(solution + harness);

DEFINE FIELD solution ON problems TYPE string
  ASSERT !!$value
  PERMISSIONS
    FOR select WHERE $auth.id = author
    FOR update NONE;

DEFINE INDEX uq_problems_language_title ON problems
  FIELDS language, title UNIQUE;
