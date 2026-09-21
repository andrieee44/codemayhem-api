DEFINE FUNCTION fn::solve_problem(
  $harness: string,
  $language: string,
  $solution: string
) -> object {
  IF $language = "C" {
    RETURN http::post($COMPILERMS_URL + "/gcc", {
      headers: { "solution.c": $solution },
      sources: { "harness.c": $harness }
    })
  } ELSE IF $language = "Java" {
    RETURN http::post($COMPILERMS_URL + "/java", {
      sources: {
        "Main.java": $harness,
        "Solution.java": $solution
      }
    })
  } ELSE IF $language = "SQLite" {
    RETURN http::post($COMPILERMS_URL + "/sqlite3tmp", {
      stdin: $harness + ";" + $solution,
    })
  } ELSE {
    THROW "Unsupported language: " + $language
  }
} PERMISSIONS NONE;
