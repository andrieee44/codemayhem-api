DEFINE FUNCTION fn::retry_at(
  $limit_id: string,
  $max_count: int,
  $window: duration
) -> option<datetime> {
  LET $now: datetime = time::now();

  LET $limit: object = UPSERT ONLY type::record('ratelimits', $limit_id)
    MERGE (
      IF started_at = NONE OR started_at + $window <= $now {
        { count: 1, started_at: $now }
      } ELSE {
        { count: count + 1 }
      }
    );

  IF $limit.count > $max_count {
    RETURN $limit.started_at + $window
  };

  RETURN NONE;
} PERMISSIONS NONE;
