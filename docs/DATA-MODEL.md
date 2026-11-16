# Data model (proposed)

Status: proposal. Not built and not tested. Source IDs (Sxx) refer to docs/LEARN-SOURCES.md. Design decisions are proposals and carry no label. Factual claims are labelled.

## Storage mode

- Import mode for every table.
- Reason: the only source is one local CSV file. DirectQuery and Direct Lake need a database or Fabric source, so neither applies to a local CSV [inferred; the Learn comparison page was not read, see LEARN-SOURCES gaps].
- The written comparison for objective 1.1.3 goes in docs/decisions/storage-mode.md (Phase 1, task P1-04).

## Grain

- One row in FactBooking = one booking (one row of the CSV).
- 119,390 rows [verified: planner brief].
- The dataset has no booking ID [not verified]. A surrogate `BookingKey` (index) is added in Power Query.

## Diagram (text)

```
                 Hotel (2)                 Country           MarketSegment
                    |1                        |1                  |1
                    |                         |                   |
 'Booking Date' 1---*  FactBooking  *---------+                   |
                       (119,390)    *-----------------------------+
 'Date' 1 ----------*  ArrivalDate  (active)
 'Date' 1 - - - - - *  StatusDate   (inactive, USERELATIONSHIP)
                       *---1 DistributionChannel
                       *---1 CustomerType
                       *---1 DepositType
                       *---1 Meal
                       *---1 RoomType (reserved room type)

 _Measures (no rows, holds measures only)
 TimeCalc (calculation group, Phase 2)
 AggBookingsMonth (optional, Phase 2 performance test only)
```

## Tables

### FactBooking

| Column | Type | Source / rule | Notes |
|---|---|---|---|
| BookingKey | Int64 | index | hidden; for distinct counts and drillthrough |
| HotelKey | Int64 | merged from Hotel (1 = City Hotel, 2 = Resort Hotel) | hidden FK |
| ArrivalDate | Date | built from year / month name / day | FK to 'Date' (active) |
| BookingDate | Date | ArrivalDate - lead_time. lead_time is the number of days from entering the booking in the PMS to arrival [verified: planner, source paper]. | FK to 'Booking Date' (active) |
| StatusDate | Date | reservation_status_date, the date the last status was set [verified: planner, source paper]. For cancelled rows this is the cancellation date [inferred]. | FK to 'Date' (inactive) |
| DepartureDate | Date | ArrivalDate + TotalNights | attribute only, no relationship |
| CountryCode | Text | country, empty -> "UNK" | FK |
| MarketSegmentCode, DistributionChannelCode, CustomerTypeCode, DepositTypeCode, MealCode, ReservedRoomTypeCode | Text | trimmed source codes | FKs |
| AssignedRoomTypeCode | Text | source | degenerate attribute (see role-playing below) |
| AgentId, CompanyId | Int64 (nullable) | "NULL" -> null. "NULL" means "not applicable" [verified: planner, source paper]. | degenerate; summarizeBy None |
| AgentLabel, CompanyLabel | Text | "Not applicable" when the ID is null, otherwise the ID as text | degenerate; used on axes and slicers |
| HasAgent, HasCompany | Logical | derived | |
| ReservationStatus | Text | source | degenerate (3 values [not verified]) |
| IsCanceled, IsRepeatedGuest | Int64 0/1 | source | |
| LeadTimeDays, WeekendNights, WeekNights, TotalNights, Adults, Children, Babies, TotalGuests, BookingChanges, DaysInWaitingList, PreviousCancellations, PreviousBookingsNotCanceled, RequiredCarParkingSpaces, TotalSpecialRequests | Int64 | source / derived | numeric facts |
| AdrRaw | Decimal | source | hidden; audit only |
| AdrClean | Decimal | negative -> null | used by measures |
| IsAdrNegative, IsAdrZero, IsAdrOutlier, IsRoomChanged, IsZeroGuest, IsZeroNight | Logical | derived flags | |
| arrival_date_week_number | removed | | Not needed; the Date table gives week numbers. Removing it supports objective 2.3.1. |

### Hotel

- Columns: HotelKey (Int64), HotelName (Text). Two rows.
- Purpose: the RLS filter target (static roles per hotel).
- An integer surrogate key is used here only. It covers objective 1.3.9 and shows a Power Query merge used to look up a key.

### 'Date' (arrival and status roles)

- Built in Power Query from a list of dates. One row per day.
- Range: 1 January of the year of the earliest date in (BookingDate, ArrivalDate, StatusDate), to 31 December of the year of the latest date in (DepartureDate, StatusDate).
- Full years and no gaps, as required [verified: S18]. Marked as date table [verified: S19 for the UI path].
- Columns: Date, Year, QuarterNumber, Quarter ("Q1"), MonthNumber, MonthName (sort by MonthNumber), MonthShort, YearMonth (Int, yyyymm), YearMonthLabel (sort by YearMonth), WeekdayNumber, WeekdayName (sort by WeekdayNumber), IsWeekend, ISOWeek [verify the M function for ISO week before use], DayOfMonth.
- The exact range is to be computed in Phase 1. Lead times of several hundred days push BookingDate back before 2015 [not verified].

### 'Booking Date' (booking role)

- Calculated table: `'Booking Date' = 'Date'`. This covers objectives 2.1.5 and 2.2.7.
- A DAX clone copies columns but not formats, sort-by settings or descriptions [verified: S18]. Those must be set again by hand (task P2-03).
- Column names get a "Booking " prefix, for example 'Booking Date'[Booking Year], so field lists are self-describing as S21 recommends [verified: S21].
- Not marked as a date table. Time intelligence runs on 'Date' only.

### Small dimensions (natural text keys)

| Table | Key | Attributes |
|---|---|---|
| Country | CountryCode | CountryLabel (code, or "Unknown" for UNK). Optional later: country name from a verified ISO list (owner decision R13). |
| MarketSegment | MarketSegmentCode | label |
| DistributionChannel | DistributionChannelCode | label |
| CustomerType | CustomerTypeCode | label |
| DepositType | DepositTypeCode | label |
| Meal | MealCode | MealDescription, merged from a small JSON lookup (objectives 1.3.5 and 1.3.8). The descriptions come from the dataset paper. "Undefined" and "SC" both mean no meal package [verified: planner, source paper]. The other code descriptions are still to be copied from the paper by the owner [not verified]. |
| RoomType | RoomTypeCode | label. The codes are anonymised letters [not verified]. |

- These dimensions are built as **reference** queries of the staging query (Table.Distinct on the code column). Duplicate queries are not used: a reference re-uses the staging logic, so a fix in staging flows through to all of them. This covers objective 1.3.7 [inferred; reference vs duplicate behaviour not read on Learn].
- The staging query has load disabled (objective 1.3.10).

### _Measures

- Empty table that holds all measures. Created with Enter data or as a calculated table, then hidden.
- Reason: measures do not sit in the fact or Hotel table. USERELATIONSHIP cannot be used when RLS is defined on the table that holds the measure [verified: S23]. With RLS on Hotel and measures in _Measures, the documented restriction should not apply [inferred]. The RLS page also warns that USERELATIONSHIP with RLS "may cause errors" in general [verified: S33]. Phase 4 test P4-03 checks this.

### TimeCalc (calculation group)

- Items: Current, PY, YoY %, YTD. See MEASURES.md C01-C04.
- Desktop asks to turn on "discourage implicit measures" when a calculation group is created [verified: S50].

### AggBookingsMonth (optional)

- Power Query Group By of the staging query to (HotelKey, MonthStart of ArrivalDate, IsCanceled) with BookingCount and RoomNights.
- Used in task P2-11 to compare model size and visual timing against the detailed fact (objective 2.3.3).
- Removed afterwards unless it pays off.

## Relationships

| # | From (many) | To (one) | Cardinality | Direction | Active | Reason |
|---|---|---|---|---|---|---|
| R1 | FactBooking[HotelKey] | Hotel[HotelKey] | *:1 | Single | Yes | RLS filter path. RLS only flows over active relationships [verified: S22]. |
| R2 | FactBooking[ArrivalDate] | 'Date'[Date] | *:1 | Single | Yes | Main reporting date |
| R3 | FactBooking[StatusDate] | 'Date'[Date] | *:1 | Single | **No** | Role-playing via USERELATIONSHIP (objective 2.1.2) |
| R4 | FactBooking[BookingDate] | 'Booking Date'[Date] | *:1 | Single | Yes | Role-playing via a separate table, so arrival and booking can filter together |
| R5 | FactBooking[CountryCode] | Country[CountryCode] | *:1 | Single | Yes | |
| R6 | FactBooking[MarketSegmentCode] | MarketSegment[...] | *:1 | Single | Yes | |
| R7 | FactBooking[DistributionChannelCode] | DistributionChannel[...] | *:1 | Single | Yes | |
| R8 | FactBooking[CustomerTypeCode] | CustomerType[...] | *:1 | Single | Yes | |
| R9 | FactBooking[DepositTypeCode] | DepositType[...] | *:1 | Single | Yes | |
| R10 | FactBooking[MealCode] | Meal[MealCode] | *:1 | Single | Yes | |
| R11 | FactBooking[ReservedRoomTypeCode] | RoomType[RoomTypeCode] | *:1 | Single | Yes | |

- Many-to-one with single direction is the default and the standard star pattern [verified: S24, S21]. No bi-directional filters.
- Only one active relationship may exist between two tables [verified: S22]. R2 is active and R3 is inactive.

## Role-playing dates: the reasoning

Three date roles exist: arrival, booking (arrival minus lead time) and status (check-out or cancellation date).

- **Arrival**: the main business date. Active relationship to the marked 'Date' table, so all time intelligence works on arrival.
- **Booking**: the report needs a matrix of arrival month by booking month (booking window analysis). That needs two date roles filtering at the same time. A single date table with an inactive relationship cannot do this [verified: S21, S22]. So booking date gets its own table.
- **Status**: used for one question only, "cancellations by the date they were cancelled". No visual needs it together with another role at the same time. An inactive relationship plus USERELATIONSHIP in a measure is enough [verified: S22 recommends inactive relationships for this case], and it shows the second pattern for the exam.
- **Fallback**: if P4-03 shows USERELATIONSHIP fails with RLS enabled, replace R3 with a third table 'Status Date' (calculated clone) and an active relationship. The measure M19 then becomes a plain measure.

## Alternatives considered and rejected

| Alternative | Why rejected |
|---|---|
| One flat table (no star) | Fails the purpose (objectives 1.3.6, 2.1.x). The star schema is the recommended pattern [verified: S21]. |
| One date table with all three roles inactive except arrival | Booking and arrival cannot filter at the same time [verified: S21]. Rejected for booking date; kept for status date. |
| Three separate date tables | Works, but then USERELATIONSHIP is not shown at all. Kept as the fallback. |
| Date table in DAX (CALENDARAUTO) | Valid [verified: S18]. Power Query is preferred so the date logic sits next to the other cleaning steps and can be version-controlled as M text. CALENDARAUTO scans every date column in the model, which gives less control over the range [verified: S18 describes it as covering all model dates]. |
| Auto date/time | It cannot let one date table filter several tables [verified: S18]. Turned off for the file (P2-02). |
| Calendar-based time intelligence | Preview feature [verified: S32]. The portfolio should use GA features. Revisit if it becomes GA. |
| Junk dimension for meal / deposit / customer type / repeated guest | A valid pattern [verified: S21]. Rejected so that each attribute is easy to find in the field list. With small dimensions at this size the cost is negligible [inferred]. |
| Agent and Company dimensions | The IDs have no attributes in the file [not verified: the paper's description of the IDs was not reported]. "NULL" means not applicable [verified: planner, source paper]. A dimension would add nothing. They stay as degenerate columns in the fact table [verified: S21 describes degenerate dimensions]. |
| Assigned room type as a second role on RoomType (inactive) | Low value. The useful analysis is "room changed or not", which is a flag. |
| Integer surrogate keys on every dimension | No real benefit at about 120k rows [inferred]. Adds a merge per dimension. Used only on Hotel, as the demonstration. |
| A stay-night fact (one row per occupied night) for occupancy | The hotels' room capacity is not in the dataset [not verified], so occupancy % cannot be computed. Possible later extension. |
| Bi-directional relationships | Not needed in a single star. They add ambiguity risk [verified: S24]. |
| Unpivoted stay-nights table in the model | The weekend/week split can be done with two measures. The unpivot stays as a practice query (load disabled) to cover objective 1.3.4. |

## Properties to set (objective 2.1.1)

- Hide all key columns and raw columns (BookingKey, HotelKey, AdrRaw, the FK codes on the fact side).
- Set sort-by-column for month and weekday names on both date tables.
- Set summarizeBy = None on IDs, year and flags.
- Set format strings: percent for rates, a fixed decimal for ADR (currency not stated in the dataset [not verified], so no currency symbol by default), whole numbers for counts.
- Data category: Country[CountryCode] could be set to a country category. The codes are 3-letter [not verified]. Check that the map visual reads them correctly before relying on it.
- Write descriptions on every measure. In TMDL they are `///` lines above the object [verified: S07].
- Display folders on measures: Volume, Cancellation, Revenue, Lead time, Time intelligence.
