// stg_Bookings  [not tested]
// The cleaned staging table: the last step of stg_Bookings_Steps.
// Load: disabled. The fact and dimension queries (not drafted yet) will
// reference this query (DATA-MODEL.md, task P1-10).
// Expected: 119,390 rows.

let
    Result = stg_Bookings_Steps[Final]
in
    Result
