# Data quality

Status: plan only. CC has not opened the dataset. Every "expected" number below has to be checked in Power BI Desktop during Phase 1. Replace "to verify" with the observed value and the date checked.

Labels: `[verified: planner brief]` means the number comes from the planner's brief of 2026-11-16 and CC did not re-check it. `Sxx` IDs refer to docs/LEARN-SOURCES.md.

## Baseline (from the brief)

| Item | Value | Label |
|---|---|---|
| Rows | 119,390 | [verified: planner brief] |
| Columns | 32 | [verified: planner brief] |
| City Hotel rows | 79,330 | [verified: planner brief] |
| Resort Hotel rows | 40,060 | [verified: planner brief] |
| Arrival years | 2015-2017 | [verified: planner brief] |
| Cancellation rate | 37.0% | [verified: planner brief] |

## Verified profile facts (added 2026-11-16)

The planner profiled the owner's file. CC did not re-run it.

| ID | Fact | Label |
|---|---|---|
| V-01 | is_canceled = 1 includes No-Show. Canceled 43,017 + No-Show 1,207 = 44,224. All Check-Out rows have is_canceled = 0. Cancellation rate 37.0%. | [verified: data profile 2026-11-16, planner] |
| V-02 | adr = 0 in 1,959 rows: 1,746 Check-Out, 187 Canceled, 26 No-Show. Complementary is the largest market segment among them (680). | [verified: data profile 2026-11-16, planner] |
| V-03 | Exactly one adr above 1,000: 5,400, City Hotel, Canceled. Exactly one negative adr: -6.38. | [verified: data profile 2026-11-16, planner] |
| V-04 | 715 bookings with zero nights. 180 bookings with zero guests. 4 rows with children = "NA". | [verified: data profile 2026-11-16, planner] |
| V-05 | 26 distinct arrival year-month pairs, 2015-2017. | [verified: data profile 2026-11-16, planner] |
| V-06 | The arrival year-months are contiguous. 2015 = July to December (21,996 rows). 2016 = January to December (56,707 rows). 2017 = January to August (40,687 rows). 26 months in total. 2015 and 2017 are partial calendar years, 2016 is complete, and no month inside the range is missing. | [verified: data profile 2026-11-16, planner] |

Consequences:
- DQ-15 is confirmed. Measure M02 counts no-shows as cancellations, and M04 isolates them.
- The 5,400 row is a cancelled booking, so it does not enter the realized revenue measures (M08, M09). It still affects M10 (simple average including cancelled) and M15 if the filter is changed.
- The arrival data covers 26 of the 36 months in 2015-2017. No month inside the range is missing (V-06). The 10 absent calendar months are January to June 2015 and September to December 2017, at the two ends of the range [inferred: from V-06].
- July and August are the only months present in all three years [inferred: arithmetic from V-06].

Column names used below are those of the published file as CC remembers them. Check them against the file header before writing any M code [not verified]. The list: hotel, is_canceled, lead_time, arrival_date_year, arrival_date_month, arrival_date_week_number, arrival_date_day_of_month, stays_in_weekend_nights, stays_in_week_nights, adults, children, babies, meal, country, market_segment, distribution_channel, is_repeated_guest, previous_cancellations, previous_bookings_not_canceled, reserved_room_type, assigned_room_type, booking_changes, deposit_type, agent, company, days_in_waiting_list, customer_type, adr, required_car_parking_spaces, total_of_special_requests, reservation_status, reservation_status_date.

## Principles

1. **No row is deleted by default.** The dataset has no booking ID, so identical rows may be different bookings [inferred]. Every rule below either converts a value or adds a flag. The fact table must still have 119,390 rows at the end.
2. **Keep the raw value next to the cleaned value** when a rule changes a number that feeds a measure (adr), so the change can be audited.
3. **Convert types with an explicit culture ("en-US").** The CSV uses "." as the decimal separator [not verified]. Desktop uses the OS regional format by default, and a mismatch produces error values [verified: S15]. Table.TransformColumnTypes accepts a culture argument [verified: S10].
4. **Replace text placeholders before converting types.** If "NULL" is still there when the column is converted to a number, the conversion is expected to give errors [inferred from S15].
5. **Run profiling on the entire data set.** By default profiling covers only the first 1,000 rows [verified: S16].

## Known issues (from the brief)

### DQ-01 "NULL" text in agent

- Observed: 16,340 rows hold the text "NULL" [verified: planner brief].
- Meaning: probably "no travel agent" [not verified; check the dataset paper].
- Rule (Power Query):
  ```
  ReplacedAgent = Table.ReplaceValue(Promoted, "NULL", null, Replacer.ReplaceValue, {"agent"})
  ```
  `Replacer.ReplaceValue` matches whole values only, so an agent ID that merely contains "NULL" is not touched [verified: S09].
  Then convert to `Int64.Type` with culture "en-US". Add `HasAgent = [agent] <> null` (logical).
- Effect to verify: row count unchanged (119,390). Null count in agent = 16,340. Conversion errors in agent = 0. HasAgent false = 16,340.

### DQ-02 "NULL" text in company

- Observed: 112,593 rows hold "NULL" [verified: planner brief].
- Rule: same as DQ-01 on {"company"}. Add `HasCompany`.
- Effect to verify: rows unchanged. Null count = 112,593. Errors = 0.
- Model note: about 94% of the column is empty (112,593 / 119,390) [inferred: arithmetic]. Company stays a degenerate attribute in the fact table. It is not a dimension (see DATA-MODEL.md).

### DQ-03 Empty country

- Observed: 488 rows with an empty country [verified: planner brief].
- Uncertain: whether the raw file holds an empty string or the text "NULL" for these rows. The brief says "empty" [not verified which one]. The rule handles both.
- Rule:
  ```
  CountryFixed = Table.ReplaceValue(Prev, each [country], each if [country] = null or [country] = "" or [country] = "NULL" then "UNK" else [country], Replacer.ReplaceValue, {"country"})
  ```
  A simpler form is two Table.ReplaceValue steps ("" -> "UNK", then "NULL" -> "UNK"). The Country dimension gets one row `UNK` with the label "Unknown".
- Effect to verify: rows unchanged. Count of `UNK` = 488. No blank CountryCode in the fact. Every fact CountryCode matches a Country row (check for an orphan or blank member in the relationship).

### DQ-04 Negative adr

- Observed: one row with adr = -6.38 [verified: planner brief].
- Rule:
  - Keep `AdrRaw` (number, culture "en-US").
  - Add `AdrClean = if [AdrRaw] < 0 then null else [AdrRaw]`.
  - Add flag `IsAdrNegative`.
  - All revenue and ADR measures use AdrClean.
- Effect to verify: rows unchanged. IsAdrNegative true = 1. AdrClean null count = 1 plus any nulls already in adr (expected 0 [not verified]).

### DQ-05 adr = 0

- Observed: 1,959 rows [verified: planner brief].
- Split: 1,746 Check-Out, 187 Canceled, 26 No-Show. The largest market segment is Complementary (680) [verified: data profile 2026-11-16, planner].
- Meaning: partly complimentary stays. The other 1,279 rows are in other segments, and whether they are missing data is [not verified].
- Rule: keep the value. Add flag `IsAdrZero`. Measures provide one ADR variant that includes zeros and one that excludes them (MEASURES.md M11).
- Effect to verify: rows unchanged. IsAdrZero true = 1,959. Record the split by market segment in this file.

### DQ-06 adr maximum 5,400

- Observed: max = 5,400 [verified: planner brief]. It is the only adr above 1,000, and the booking is City Hotel and Canceled [verified: data profile 2026-11-16, planner].
- Meaning: probably a data entry error [not verified].
- Rule: keep the value. Add flag `IsAdrOutlier`. The threshold is an open question (RISKS R12). Proposal: flag rows above the 99.9th percentile, or use a fixed cut-off the owner chooses after looking at the box plot. Phase 3 shows the outlier on the "Insights" page (objective 3.3.5).
- Effect to verify: rows unchanged. Record the threshold and the flagged count.

## Candidate issues (not in the brief; check in Phase 1)

CC remembers these from public discussions of this dataset. Each one is a check, not a rule, until it is confirmed. DQ-07, DQ-08, DQ-09 and DQ-15 are now confirmed by the planner's profile (V-01, V-04). The rest stay [not verified].

| ID | Check | Proposed rule if confirmed | Effect to verify |
|---|---|---|---|
| DQ-07 | children holds "NA" text. **Confirmed: 4 rows** [verified: data profile 2026-11-16, planner]. | Replace "NA" with null before the type change. TotalGuests treats null children as 0. | errors = 0 in children; null children = 4 |
| DQ-08 | Bookings with adults + children + babies = 0. **Confirmed: 180** [verified: data profile 2026-11-16, planner]. | Flag `IsZeroGuest`. Do not delete. Measures that use guests exclude them. | IsZeroGuest = 180 (computed after DQ-07) |
| DQ-09 | Bookings with 0 total nights (day use). **Confirmed: 715** [verified: data profile 2026-11-16, planner]. | Flag `IsZeroNight`. Revenue for these rows is 0 by construction (adr * 0). Note this in MEASURES.md. | IsZeroNight = 715 |
| DQ-10 | "Undefined" values in meal, market_segment, distribution_channel | Keep them as their own dimension member, labelled "Undefined". Check whether the paper says meal "Undefined" equals "SC". | counts recorded |
| DQ-11 | Country code inconsistencies (for example a 2-letter code next to the 3-letter ISO codes) | List all codes whose length is not 3. Owner decides whether to map them. | list recorded |
| DQ-12 | Exact duplicate rows | Count them with Table.Distinct in a practice query (load disabled). Do not remove them, because there is no booking ID. | count recorded |
| DQ-13 | arrival_date_month is a month name, not a number | Map it with `List.PositionOf({"January",...,"December"}, [arrival_date_month]) + 1`, which works the same in any culture. | no -1 / 0 results |
| DQ-14 | reservation_status_date text format | Check the format. If it is ISO (yyyy-mm-dd), convert it with culture "en-US". | errors = 0 |
| DQ-15 | is_canceled = 1 also covers reservation_status "No-Show". **Confirmed:** Canceled 43,017 + No-Show 1,207 = 44,224, and Check-Out rows are all 0 [verified: data profile 2026-11-16, planner]. | No rule needed. MEASURES.md M02 and M04 rely on it. | cross-tab matches in Desktop |
| DQ-16 | Extra whitespace or case differences in text codes | Apply Text.Trim to the code columns. Check distinct counts before and after. | distinct counts equal or explained |

## Derived columns (Phase 1)

| Column | Rule (sketch) | Label |
|---|---|---|
| BookingKey | Table.AddIndexColumn starting at 1. A surrogate key, because the dataset has no ID. | [not verified: function page not read] |
| ArrivalDate | `#date([arrival_date_year], MonthNumber, [arrival_date_day_of_month])` | [inferred] |
| TotalNights | weekend nights + week nights | [inferred] |
| DepartureDate | `Date.AddDays([ArrivalDate], [TotalNights])` | Date.AddDays [verified: S14] |
| BookingDate | `Date.AddDays([ArrivalDate], -[lead_time])`. Assumes lead_time is the number of days between booking and arrival. | meaning [not verified] |
| StatusDate | reservation_status_date as date. For cancelled rows it is assumed to be the cancellation date. | meaning [not verified] |
| TotalGuests | adults + (children ?? 0) + babies | [inferred] |
| IsRoomChanged | reserved_room_type <> assigned_room_type | [inferred] |
| IsCanceled | is_canceled as Int64 (0/1) | [inferred] |

## Row-count ledger (fill in during Phase 1)

| Step | Expected rows | Observed rows | Errors | Checked on |
|---|---|---|---|---|
| Source (after headers promoted) | 119,390 | to verify | to verify | |
| After NULL / empty replacements | 119,390 | to verify | to verify | |
| After type conversion | 119,390 | to verify | 0 expected | |
| After derived columns | 119,390 | to verify | 0 expected | |
| FactBooking loaded (DAX: `EVALUATE ROW("n", COUNTROWS(FactBooking))`) | 119,390 | to verify | | |
| Hotel dimension | 2 | to verify | | |
| Country dimension (includes UNK) | to verify | to verify | | |

## How to verify (owner, in Desktop)

1. Power Query editor > View > turn on Column quality, Column distribution, Column profile. Switch to "Column profiling based on entire data set" [verified: S16].
2. On each query: right-click a column > Keep errors. Expect 0 rows. Then remove that step again.
3. After loading, use DAX query view > table > "Show column statistics" [verified: S53] and copy the counts into the ledger above.
4. Note the observed values in this file and commit. Do not paste raw data rows.
