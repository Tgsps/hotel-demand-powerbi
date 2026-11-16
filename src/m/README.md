# src/m: draft Power Query M for Phase 1

Status: **[not tested]**. None of these queries has been run in Power BI Desktop.

| File | Query name | Load | Purpose |
|---|---|---|---|
| `DataFolderPath.pq` | DataFolderPath | (parameter) | Folder that holds `hotels.csv`. The value is a placeholder (R04, pending). |
| `src_Hotels.pq` | src_Hotels | disabled | Reads the CSV and promotes headers |
| `stg_Bookings_Steps.pq` | stg_Bookings_Steps | disabled | Cleaning steps DQ-01 to DQ-09, DQ-13, DQ-16. Returns a record of step tables. |
| `stg_Bookings.pq` | stg_Bookings | disabled | Final cleaned staging table |
| `chk_RowCounts.pq` | chk_RowCounts | disabled | Row count per step (expected 119,390) |
| `chk_Values.pq` | chk_Values | disabled | Value counts against DATA-QUALITY.md |

The fact, dimension, Date and aggregation queries are not drafted yet.

## Owner steps in Power BI Desktop

1. Copy `hotels.csv` into `data/` in the clone, if it is not already there.
2. Open a new, blank report in Power BI Desktop. Go to Home > Transform data to open the Power Query editor.
3. Create the parameter: Home > Manage parameters > New parameter.
   - Name: `DataFolderPath`
   - Type: Text
   - Required: on
   - Current value: the full path of your clone's `data` folder, ending with a backslash
   - Do not commit this value.
4. For each of the other files, in this order: `src_Hotels`, `stg_Bookings_Steps`, `stg_Bookings`, `chk_RowCounts`, `chk_Values`:
   - Home > New source > Blank query.
   - Rename the query to the exact name in the table above.
   - Open Advanced Editor, replace its content with the file's content, and select Done.
   - Comment lines starting with `//` are fine to paste.
5. Right-click each of these queries and clear "Enable load": `src_Hotels`, `stg_Bookings_Steps`, `stg_Bookings`, `chk_RowCounts`, `chk_Values`.
6. If Desktop asks for a privacy level for the file source, choose one and record it (task P1-03). If a Formula.Firewall error appears, record the exact message and do not set "Ignore privacy levels".
7. Open `chk_RowCounts` and `chk_Values`. Every `Ok` value should be TRUE.
   - Copy the numbers into the row-count ledger in `docs/DATA-QUALITY.md`.
   - Record any FALSE row together with its Rows value.
8. Check for type-conversion errors:
   - On `stg_Bookings`, select all columns, then Home > Keep rows > Keep errors. Expect 0 rows. Then delete that step again.
   - Switch on column profiling for the entire data set (View tab), as described in DATA-QUALITY.md "How to verify".
9. DQ-08: record whether any of the 4 rows with null `children` is among the 180 zero-guest rows. One way: filter `stg_Bookings` on `children` = null and look at `IsZeroGuest`.
10. Report back:
    - the two check tables,
    - any error message, with the step name,
    - anything that had to be changed to make a query run.

    CC will update the `.pq` files to match. Do not save the report as PBIP yet; that is task P1-18, after the queries work.
