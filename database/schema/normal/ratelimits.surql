DEFINE TABLE ratelimits SCHEMAFULL TYPE NORMAL
  PERMISSIONS
    FOR create, select, update, delete NONE;

DEFINE FIELD id         ON ratelimits TYPE string;
DEFINE FIELD count      ON ratelimits TYPE int      DEFAULT 1;
DEFINE FIELD started_at ON ratelimits TYPE datetime DEFAULT time::now();
