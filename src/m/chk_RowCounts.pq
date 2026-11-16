// chk_RowCounts  [not tested]
// One row-count check per step of stg_Bookings_Steps. Load: disabled.
// Use: open it in the Power Query editor and copy the Rows column into the
// row-count ledger in docs/DATA-QUALITY.md. Every Ok value should be TRUE.
// Expected 119,390 for every step: no step removes rows
// [verified: planner brief; file check 2026-11-16].
//
// Functions: Table.FromRecords (S61), Table.RowCount (S60), Table.AddColumn (S13).
// Each count re-reads the CSV, so this query is slow; that is expected.

let
    S = stg_Bookings_Steps,
    Expected = 119390,
    Counts = Table.FromRecords({
        [Step = "s01_Source", Rows = Table.RowCount(S[s01_Source]), Expected = Expected],
        [Step = "s02_Trimmed", Rows = Table.RowCount(S[s02_Trimmed]), Expected = Expected],
        [Step = "s03_AgentCompanyNull", Rows = Table.RowCount(S[s03_AgentCompanyNull]), Expected = Expected],
        [Step = "s04_CountryFromNULL", Rows = Table.RowCount(S[s04_CountryFromNULL]), Expected = Expected],
        [Step = "s05_CountryFromEmpty", Rows = Table.RowCount(S[s05_CountryFromEmpty]), Expected = Expected],
        [Step = "s06_CountryFromNull", Rows = Table.RowCount(S[s06_CountryFromNull]), Expected = Expected],
        [Step = "s07_ChildrenNA", Rows = Table.RowCount(S[s07_ChildrenNA]), Expected = Expected],
        [Step = "s08_Typed", Rows = Table.RowCount(S[s08_Typed]), Expected = Expected],
        [Step = "s09_AgentCompanyLabels", Rows = Table.RowCount(S[s09_AgentCompanyLabels]), Expected = Expected],
        [Step = "s10_AdrFlags", Rows = Table.RowCount(S[s10_AdrFlags]), Expected = Expected],
        [Step = "s11_GuestsNights", Rows = Table.RowCount(S[s11_GuestsNights]), Expected = Expected],
        [Step = "s12_ArrivalMonthNumber", Rows = Table.RowCount(S[s12_ArrivalMonthNumber]), Expected = Expected],
        [Step = "s13_WithKey", Rows = Table.RowCount(S[s13_WithKey]), Expected = Expected],
        [Step = "Final (stg_Bookings)", Rows = Table.RowCount(stg_Bookings), Expected = Expected]
    }),
    Checked = Table.AddColumn(Counts, "Ok", each [Rows] = [Expected], type logical)
in
    Checked
