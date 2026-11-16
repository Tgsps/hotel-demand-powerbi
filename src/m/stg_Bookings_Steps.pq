// stg_Bookings_Steps  [not tested]
// Task P1-06 / P1-08. Cleaning rules from docs/DATA-QUALITY.md:
//   DQ-01, DQ-02, DQ-03, DQ-04, DQ-05, DQ-06, DQ-07, DQ-08, DQ-09, DQ-13, DQ-16.
// Load: disabled.
//
// This query returns a RECORD with one field per step (each a table).
// stg_Bookings returns the last step. chk_RowCounts and chk_Values read
// each step so the owner can fill in the row-count ledger in DATA-QUALITY.md.
// No step removes rows: every step is expected to keep 119,390 rows.
//
// Column names are the header listed in DATA-QUALITY.md, which matches the
// file exactly [verified: planner, direct read 2026-11-16].
// DQ-14 (reservation_status_date type) is not in this draft; the column
// stays text until its format rule is written.
//
// Functions (docs/LEARN-SOURCES.md): Table.TransformColumns (S57),
// Text.Trim (S58), Table.ReplaceValue (S09), Table.TransformColumnTypes (S10),
// Table.AddColumn (S13), List.PositionOf (S59), Text.From (S63),
// Table.AddIndexColumn (S56).

let
    Source = src_Hotels,

    // DQ-16: trim leading and trailing whitespace on text code columns,
    // and on the three columns that hold "NULL" / "NA" text, before any
    // replacement or type change. Text.Trim trims whitespace by default (S58).
    Trimmed = Table.TransformColumns(
        Source,
        {
            {"hotel", Text.Trim, type text},
            {"arrival_date_month", Text.Trim, type text},
            {"meal", Text.Trim, type text},
            {"country", Text.Trim, type text},
            {"market_segment", Text.Trim, type text},
            {"distribution_channel", Text.Trim, type text},
            {"reserved_room_type", Text.Trim, type text},
            {"assigned_room_type", Text.Trim, type text},
            {"deposit_type", Text.Trim, type text},
            {"customer_type", Text.Trim, type text},
            {"reservation_status", Text.Trim, type text},
            {"agent", Text.Trim, type text},
            {"company", Text.Trim, type text},
            {"children", Text.Trim, type text}
        }
    ),

    // DQ-01, DQ-02: "NULL" means "not applicable" [verified: planner, source paper].
    // Whole-value replace only (Replacer.ReplaceValue, S09). Null is kept so the
    // columns can be typed as whole numbers.
    AgentCompanyNull = Table.ReplaceValue(Trimmed, "NULL", null, Replacer.ReplaceValue, {"agent", "company"}),

    // DQ-03: the 488 rows hold the text "NULL" [verified: planner, direct read
    // 2026-11-16]. Empty text and null are handled too, in case another copy differs.
    CountryFromNULL = Table.ReplaceValue(AgentCompanyNull, "NULL", "UNK", Replacer.ReplaceValue, {"country"}),
    CountryFromEmpty = Table.ReplaceValue(CountryFromNULL, "", "UNK", Replacer.ReplaceValue, {"country"}),
    // Replacing a null oldValue this way is [not verified]; chk_Values counts UNK.
    CountryFromNull = Table.ReplaceValue(CountryFromEmpty, null, "UNK", Replacer.ReplaceValue, {"country"}),

    // DQ-07: 4 rows hold children = "NA" [verified: data profile 2026-11-16, planner].
    ChildrenNA = Table.ReplaceValue(CountryFromNull, "NA", null, Replacer.ReplaceValue, {"children"}),

    // Explicit types with culture "en-US", so "." is read as the decimal
    // separator whatever the Windows regional format is (S10, S15).
    Typed = Table.TransformColumnTypes(
        ChildrenNA,
        {
            {"hotel", type text},
            {"is_canceled", Int64.Type},
            {"lead_time", Int64.Type},
            {"arrival_date_year", Int64.Type},
            {"arrival_date_month", type text},
            {"arrival_date_week_number", Int64.Type},
            {"arrival_date_day_of_month", Int64.Type},
            {"stays_in_weekend_nights", Int64.Type},
            {"stays_in_week_nights", Int64.Type},
            {"adults", Int64.Type},
            {"children", Int64.Type},
            {"babies", Int64.Type},
            {"meal", type text},
            {"country", type text},
            {"market_segment", type text},
            {"distribution_channel", type text},
            {"is_repeated_guest", Int64.Type},
            {"previous_cancellations", Int64.Type},
            {"previous_bookings_not_canceled", Int64.Type},
            {"reserved_room_type", type text},
            {"assigned_room_type", type text},
            {"booking_changes", Int64.Type},
            {"deposit_type", type text},
            {"agent", Int64.Type},
            {"company", Int64.Type},
            {"days_in_waiting_list", Int64.Type},
            {"customer_type", type text},
            {"adr", type number},
            {"required_car_parking_spaces", Int64.Type},
            {"total_of_special_requests", Int64.Type},
            {"reservation_status", type text},
            {"reservation_status_date", type text}
        },
        "en-US"
    ),

    // DQ-01, DQ-02: flags and display labels.
    HasAgent = Table.AddColumn(Typed, "HasAgent", each [agent] <> null, type logical),
    AgentLabel = Table.AddColumn(HasAgent, "AgentLabel", each if [agent] = null then "Not applicable" else Text.From([agent], "en-US"), type text),
    HasCompany = Table.AddColumn(AgentLabel, "HasCompany", each [company] <> null, type logical),
    CompanyLabel = Table.AddColumn(HasCompany, "CompanyLabel", each if [company] = null then "Not applicable" else Text.From([company], "en-US"), type text),

    // DQ-04: the raw adr column is kept unchanged (renamed to AdrRaw later, in
    // the fact query). AdrClean drops the one negative value.
    AdrClean = Table.AddColumn(CompanyLabel, "AdrClean", each if [adr] = null or [adr] < 0 then null else [adr], type number),
    IsAdrNegative = Table.AddColumn(AdrClean, "IsAdrNegative", each [adr] <> null and [adr] < 0, type logical),

    // DQ-05: keep zero rates, flag them.
    IsAdrZero = Table.AddColumn(IsAdrNegative, "IsAdrZero", each [adr] = 0, type logical),

    // DQ-06: outlier flag. The threshold is a PLACEHOLDER, not a decision:
    // the owner chooses it after profiling (R12). With 1,000 exactly one row is
    // flagged [verified: data profile 2026-11-16, planner; V-03].
    AdrOutlierThreshold = 1000,
    IsAdrOutlier = Table.AddColumn(IsAdrZero, "IsAdrOutlier", each [adr] <> null and [adr] > AdrOutlierThreshold, type logical),

    // DQ-08: guests. Null children (the 4 "NA" rows) count as 0.
    TotalGuests = Table.AddColumn(IsAdrOutlier, "TotalGuests", each [adults] + (if [children] = null then 0 else [children]) + [babies], Int64.Type),
    IsZeroGuest = Table.AddColumn(TotalGuests, "IsZeroGuest", each [TotalGuests] = 0, type logical),

    // DQ-09: nights.
    TotalNights = Table.AddColumn(IsZeroGuest, "TotalNights", each [stays_in_weekend_nights] + [stays_in_week_nights], Int64.Type),
    IsZeroNight = Table.AddColumn(TotalNights, "IsZeroNight", each [TotalNights] = 0, type logical),

    // DQ-13: month name to number, the same in any culture. List.PositionOf
    // returns -1 when not found (S59), so 0 here means "name not recognised".
    MonthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"},
    ArrivalMonthNumber = Table.AddColumn(IsZeroNight, "ArrivalMonthNumber", each List.PositionOf(MonthNames, [arrival_date_month]) + 1, Int64.Type),

    // Surrogate key: the dataset has no booking ID (DATA-MODEL.md).
    WithKey = Table.AddIndexColumn(ArrivalMonthNumber, "BookingKey", 1, 1, Int64.Type)
in
    // Field names differ from the step names on purpose: inside a record,
    // [Source = Source] would refer to the field itself.
    [
        s01_Source = Source,
        s02_Trimmed = Trimmed,
        s03_AgentCompanyNull = AgentCompanyNull,
        s04_CountryFromNULL = CountryFromNULL,
        s05_CountryFromEmpty = CountryFromEmpty,
        s06_CountryFromNull = CountryFromNull,
        s07_ChildrenNA = ChildrenNA,
        s08_Typed = Typed,
        s09_AgentCompanyLabels = CompanyLabel,
        s10_AdrFlags = IsAdrOutlier,
        s11_GuestsNights = IsZeroNight,
        s12_ArrivalMonthNumber = ArrivalMonthNumber,
        s13_WithKey = WithKey,
        Final = WithKey
    ]
