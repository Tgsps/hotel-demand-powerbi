// chk_Values  [not tested]
// Value checks on stg_Bookings against the figures in docs/DATA-QUALITY.md.
// Load: disabled. Every Ok value should be TRUE. A row-count check alone does
// not show that a replace or type step worked, so these counts complement
// chk_RowCounts. Type-conversion errors are checked separately with
// "Keep errors" (DATA-QUALITY.md, "How to verify").
//
// Functions: Table.SelectRows (S12), Table.RowCount (S60), Table.FromRecords (S61).

let
    T = stg_Bookings,
    Count = (condition as function) as number => Table.RowCount(Table.SelectRows(T, condition)),
    Checks = Table.FromRecords({
        // DQ-01 [verified: planner brief]
        [Check = "agent is null", Rows = Count(each [agent] = null), Expected = 16340],
        // DQ-02 [verified: planner brief]
        [Check = "company is null", Rows = Count(each [company] = null), Expected = 112593],
        // DQ-03 [verified: planner brief; "NULL" text verified 2026-11-16]
        [Check = "country = UNK", Rows = Count(each [country] = "UNK"), Expected = 488],
        // DQ-04, DQ-05, DQ-06 [verified: planner brief; V-02, V-03]
        [Check = "IsAdrNegative", Rows = Count(each [IsAdrNegative]), Expected = 1],
        [Check = "IsAdrZero", Rows = Count(each [IsAdrZero]), Expected = 1959],
        [Check = "IsAdrOutlier (placeholder threshold 1,000)", Rows = Count(each [IsAdrOutlier]), Expected = 1],
        // DQ-07 [verified: V-04]
        [Check = "children is null", Rows = Count(each [children] = null), Expected = 4],
        // DQ-08: 180 zero-guest bookings [verified: V-04]. Whether the 4 "NA"
        // rows are among them is the open DQ-08 question: record it.
        [Check = "IsZeroGuest", Rows = Count(each [IsZeroGuest]), Expected = 180],
        // DQ-09 [verified: V-04]
        [Check = "IsZeroNight", Rows = Count(each [IsZeroNight]), Expected = 715],
        // DQ-13: no month name left unrecognised
        [Check = "ArrivalMonthNumber = 0", Rows = Count(each [ArrivalMonthNumber] = 0), Expected = 0],
        // V-01 [verified: data profile 2026-11-16, planner]
        [Check = "is_canceled = 1", Rows = Count(each [is_canceled] = 1), Expected = 44224],
        // Hotel split [verified: planner brief]
        [Check = "hotel = City Hotel", Rows = Count(each [hotel] = "City Hotel"), Expected = 79330],
        [Check = "hotel = Resort Hotel", Rows = Count(each [hotel] = "Resort Hotel"), Expected = 40060]
    }),
    Checked = Table.AddColumn(Checks, "Ok", each [Rows] = [Expected], type logical)
in
    Checked
