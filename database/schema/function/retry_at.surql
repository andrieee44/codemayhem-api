DEFINE FUNCTION fn::retry_at(
  $limit_id: string,
  $max_count: int,
  $window: duration
) -> option<datetime> {
  LET $now = time::now();

  LET $limit = UPSERT ONLY type::record('ratelimits', $limit_id)
    REPLACE {
      IF started_at = NONE OR started_at + $window <= $now {
        RETURN { count: 1, started_at: $now };
      } ELSE {
        RETURN { count: count + 1, started_at: started_at };
      }
    };

  IF $limit.count > $max_count {
    RETURN $limit.started_at + $window
  };

  RETURN NONE;
} PERMISSIONS NONE;
