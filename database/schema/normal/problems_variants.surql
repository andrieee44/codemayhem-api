DEFINE TABLE problems_variants SCHEMAFULL TYPE NORMAL
  PERMISSIONS
    FOR create, update NONE
    FOR select WHERE !!$auth
    FOR delete WHERE $auth.id = problem.author;

DEFINE FIELD id          ON problems_variants TYPE uuid;
DEFINE FIELD body        ON problems_variants TYPE string   ASSERT !!$value;
DEFINE FIELD boilerplate ON problems_variants TYPE string   ASSERT !!$value;
DEFINE FIELD created_at  ON problems_variants TYPE datetime DEFAULT time::now();
DEFINE FIELD language    ON problems_variants TYPE string   ASSERT !!$value;

DEFINE FIELD harness ON problems_variants TYPE string
  ASSERT !!$value
  PERMISSIONS
    FOR select WHERE $auth.id = problem.author;

DEFINE FIELD problem ON problems_variants
  TYPE record<problems> REFERENCE ON DELETE CASCADE
  ASSERT !!$value;

DEFINE FIELD solution ON problems_variants TYPE string
  ASSERT !!$value
  PERMISSIONS
    FOR select WHERE $auth.id = problem.author;
