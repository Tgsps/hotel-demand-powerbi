# Candidate DAX measures

Status: every measure is **[not tested]**. None has been run. Formulas are drafts against the model in DATA-MODEL.md. Source IDs (Sxx) refer to docs/LEARN-SOURCES.md.

All measures live in the `_Measures` table.

## Conventions

- Ratios use DIVIDE with no alternate result. A zero or BLANK denominator then returns BLANK [verified: S30, S31], and visuals hide empty groups [verified: S31].
- Boolean filters inside CALCULATE reference columns of one table only, and never a measure [verified: S25].
- "Realized" means not cancelled (IsCanceled = 0). IsCanceled = 1 also covers no-shows: confirmed, see DATA-QUALITY V-01.
- Revenue is an **estimate**: AdrClean x TotalNights for bookings that were not cancelled. adr is the sum of all lodging transactions divided by the total number of nights stayed [verified: planner, source paper].
- Partial years: arrivals cover 2015-2017 [verified: planner brief], and the first and last years are partial: 2015 is July to December and 2017 is January to August [verified: data profile 2026-11-16, planner; see DATA-QUALITY V-06]. Year-level comparisons across partial years are misleading. Show YoY at month level and let PY return BLANK where the prior month has no data.

## How to get these into the model

CC writes them as one DAX query view script (`DEFINE MEASURE _Measures[Name] = ...` blocks) in `src/dax/measures.dax`. The owner opens DAX query view, pastes the script, runs it, and uses "Update model with changes" [verified: S53].

After the project is saved as PBIP, CC may instead edit `_Measures.tmdl` directly. The owner then reloads or restarts Desktop [verified: S05, S06].

## Volume and cancellation

| ID | Name | Business question | Formula | Edge cases |
|---|---|---|---|---|
| M01 | Bookings | How many bookings were made? | `COUNTROWS ( FactBooking )` | Includes cancelled and no-show bookings. Expected total 119,390. |
| M02 | Canceled Bookings | How many were cancelled? | `CALCULATE ( [Bookings], FactBooking[IsCanceled] = 1 )` | Includes no-shows: confirmed (DQ-15, V-01). Expected 44,224 = 43,017 Canceled + 1,207 No-Show [verified: data profile 2026-11-16, planner]. |
| M03 | Cancellation Rate | What share of bookings was cancelled? | `DIVIDE ( [Canceled Bookings], [Bookings] )` | Expected about 37.0% overall [verified: planner brief]. BLANK when there are no bookings. |
| M04 | No-Show Bookings | How many guests did not show up? | `CALCULATE ( [Bookings], FactBooking[ReservationStatus] = "No-Show" )` | Status label spelling to verify. |
| M05 | Realized Bookings | How many bookings turned into stays? | `CALCULATE ( [Bookings], FactBooking[IsCanceled] = 0 )` | |
| M06 | Room Nights Booked | How many nights were requested? | `SUM ( FactBooking[TotalNights] )` | Zero-night bookings add 0 (DQ-09). |
| M07 | Room Nights Realized | How many nights were stayed? | `CALCULATE ( [Room Nights Booked], FactBooking[IsCanceled] = 0 )` | Approximation: assumes a stay is not shortened [not verified]. |
| M18 | Repeat Guest Share | How loyal are guests? | `DIVIDE ( CALCULATE ( [Bookings], FactBooking[IsRepeatedGuest] = 1 ), [Bookings] )` | |
| M25 | Room Change Rate | How often does the assigned room differ from the reserved room? | `DIVIDE ( CALCULATE ( [Bookings], FactBooking[IsRoomChanged] = TRUE () ), [Bookings] )` | Only meaningful for realized bookings. A variant filtered to IsCanceled = 0 could be added. |

## Revenue and ADR

| ID | Name | Business question | Formula | Edge cases |
|---|---|---|---|---|
| M08 | Revenue (est.) | How much room revenue was realized? | `CALCULATE ( SUMX ( FactBooking, FactBooking[AdrClean] * FactBooking[TotalNights] ), FactBooking[IsCanceled] = 0 )` | The negative adr row has AdrClean = BLANK and adds nothing (DQ-04). adr = 0 adds 0 (DQ-05). The 5,400 outlier is included (DQ-06), so see M08b. Zero-night rows add 0. |
| M08b | Revenue (est., excl. outliers) | Same, without suspicious rates | `CALCULATE ( [Revenue (est.)], FactBooking[IsAdrOutlier] = FALSE () )` | Depends on the outlier threshold (R12). |
| M09 | ADR (realized) | What was the average rate per stayed night? | `DIVIDE ( [Revenue (est.)], [Room Nights Realized] )` | A weighted average, not an AVERAGE of the adr column. Zero-night rows add to neither side. BLANK if there are no realized nights. |
| M10 | ADR (simple avg) | Comparison only: plain mean of booking rates | `AVERAGE ( FactBooking[AdrClean] )` | Includes cancelled bookings. Ignores BLANK [not verified for AVERAGE; function page not read]. Shown only to explain why M09 differs. |
| M11 | ADR (realized, excl. zero) | Rate without complimentary or zero-priced stays | `CALCULATE ( [ADR (realized)], FactBooking[IsAdrZero] = FALSE () )` | The difference to M09 shows the effect of the 1,959 zero-rate rows [verified count: planner brief]. |
| M15 | ADR Std Dev | How spread out are realized rates? | `CALCULATE ( STDEV.P ( FactBooking[AdrClean] ), FactBooking[IsCanceled] = 0 )` | Per booking, not per night. Very sensitive to the 5,400 outlier. STDEV.P behaviour with blanks [not verified]. |
| M16 | Avg Length of Stay | How long do guests stay? | `DIVIDE ( [Room Nights Realized], [Realized Bookings] )` | Zero-night rows pull the average down. |

## Lead time and statistics (objective 2.2.4)

| ID | Name | Business question | Formula | Edge cases |
|---|---|---|---|---|
| M12 | Avg Lead Time (days) | How far ahead do guests book? | `AVERAGE ( FactBooking[LeadTimeDays] )` | Skewed by long lead times, so read it next to M13. |
| M13 | Median Lead Time (days) | Typical booking window | `MEDIAN ( FactBooking[LeadTimeDays] )` | [not verified: MEDIAN page not read] |
| M14 | Lead Time P90 (days) | Long-tail booking window | `PERCENTILE.INC ( FactBooking[LeadTimeDays], 0.9 )` | [not verified: function page not read] |
| M17 | Guests (realized) | How many people stayed? | `CALCULATE ( SUM ( FactBooking[TotalGuests] ), FactBooking[IsCanceled] = 0 )` | Children nulls are treated as 0 in Power Query (DQ-07). Zero-guest rows (DQ-08) add 0. |

## Role-playing date measures

| ID | Name | Business question | Formula | Edge cases |
|---|---|---|---|---|
| M19 | Cancellations by Cancel Date | When do cancellations happen (not when the stay was planned)? | `CALCULATE ( [Canceled Bookings], USERELATIONSHIP ( FactBooking[StatusDate], 'Date'[Date] ) )` | USERELATIONSHIP takes many-side column first, the relationship must exist, and it works inside CALCULATE [verified: S23]. RLS conflict risk [verified: S23, S33]: test P4-03, with a fallback in DATA-MODEL.md. Assumes StatusDate is the cancel date for cancelled rows [not verified]. |
| M20 | Bookings Made (by booking date) | When were bookings made? | `[Bookings]`, used with 'Booking Date' fields on the axis | No separate formula is needed because R4 is active. Listed so the report spec refers to it. |

## Time intelligence (objective 2.2.3)

These need 'Date' marked as a date table [verified: S26], with no missing dates [verified: S32].

| ID | Name | Formula | Edge cases |
|---|---|---|---|
| M21 | Bookings PY | `CALCULATE ( [Bookings], SAMEPERIODLASTYEAR ( 'Date'[Date] ) )` | BLANK for months with no data a year earlier (the start of 2015). SAMEPERIODLASTYEAR has special month-end behaviour [verified: S27]. |
| M22 | Bookings YoY % | `VAR cur = [Bookings] VAR py = [Bookings PY] RETURN IF ( NOT ISBLANK ( cur ) && NOT ISBLANK ( py ), DIVIDE ( cur - py, py ) )` | Returns BLANK unless both periods have data. This avoids -100% or +inf for the partial years. |
| M23 | Bookings YTD | `TOTALYTD ( [Bookings], 'Date'[Date] )` | Calendar year end (the default is 31 December [verified: S28]). |
| M24 | Revenue YTD | `TOTALYTD ( [Revenue (est.)], 'Date'[Date] )` | |
| M27 | Cancellation Rate PY | `CALCULATE ( [Cancellation Rate], SAMEPERIODLASTYEAR ( 'Date'[Date] ) )` | Ratio of ratios: the rate is recomputed for the prior period, not averaged. |
| M28 | Cancellation Rate Delta pts | `VAR cur = [Cancellation Rate] VAR py = [Cancellation Rate PY] RETURN IF ( NOT ISBLANK ( py ), cur - py )` | Formatted as percentage points. |

## Semi-additive (objective 2.2.5)

| ID | Name | Business question | Formula | Edge cases |
|---|---|---|---|---|
| M26 | On-the-Books (end of period) | At the end of a period, how many future stays were booked and not yet cancelled? | see below | A balance at a point in time: the value for a quarter is the value on its last day, not the sum of its days. This is what makes it semi-additive. |

```
On-the-Books (end of period) =
VAR AsOf = MAX ( 'Date'[Date] )
RETURN
    CALCULATE (
        [Bookings],
        REMOVEFILTERS ( 'Date' ),
        FactBooking[BookingDate] <= AsOf,
        FactBooking[ArrivalDate] > AsOf,
        FactBooking[IsCanceled] = 0 || FactBooking[StatusDate] > AsOf
    )
```

Edge cases:
- REMOVEFILTERS on 'Date' drops the arrival filter. A filter on 'Booking Date' would still apply. Decide whether the visual allows booking-date slicers on this page.
- The OR filter references two columns of the same table, which is allowed [verified: S25 allows columns from a single table].
- Bookings whose StatusDate is before their BookingDate (data error) would be counted wrongly. Count them in Phase 1.
- Near the start of the data the value is understated, because bookings made before the first arrival year are present but cancelled ones may be missing [not verified]. Show this measure only from 2016 onwards, or add a note on the page.

## Calculation group TimeCalc (objective 2.2.8)

| ID | Item | Expression | Edge cases |
|---|---|---|---|
| C01 | Current | `SELECTEDMEASURE ()` | |
| C02 | PY | `CALCULATE ( SELECTEDMEASURE (), SAMEPERIODLASTYEAR ( 'Date'[Date] ) )` | |
| C03 | YoY % | `VAR cur = SELECTEDMEASURE () VAR py = CALCULATE ( SELECTEDMEASURE (), SAMEPERIODLASTYEAR ( 'Date'[Date] ) ) RETURN IF ( NOT ISBLANK ( cur ) && NOT ISBLANK ( py ), DIVIDE ( cur - py, py ) )` | Needs a format string expression (percent) [not verified: dynamic format strings for calculation items not read]. Meaningless for measures that are already rates; restrict it to volume measures in the report. |
| C04 | YTD | `CALCULATE ( SELECTEDMEASURE (), DATESYTD ( 'Date'[Date] ) )` | Rates under YTD are recomputed on YTD totals, which is correct. |

While a calculation group exists, measures switch to the variant data type [verified: S50]. Check that format strings still display correctly.

## Quick measure (objective 2.2.6) and visual calculations (objective 3.1.11)

- Q01: the owner creates a "Running total" quick measure of [Bookings] over 'Date'[Date] in Desktop and records the DAX that Desktop generates in this file [not verified: the quick measure page was not read].
- V01: visual calculation `Running Bookings = RUNNINGSUM ( [Bookings] )` on a monthly column chart [verified: S51 lists RUNNINGSUM].
- V02: visual calculation `3-Month Avg = MOVINGAVERAGE ( [Bookings], 3 )` [verified: S51 lists MOVINGAVERAGE; exact parameters not verified].
- Visual calculations cannot use USERELATIONSHIP or RELATED, and cannot be pinned to dashboards [verified: S51].

## Verification queries (Phase 2)

For each measure, the owner runs a DAX query in DAX query view and compares it with an independent number (a Power Query Group By, or the brief). Example:

```
EVALUATE
SUMMARIZECOLUMNS (
    Hotel[HotelName],
    "Bookings", [Bookings],
    "Cancel rate", [Cancellation Rate]
)
```

Expected: City Hotel 79,330 and Resort Hotel 40,060 [verified: planner brief]. The overall cancellation rate is about 37.0%.

When a measure passes, change its label from [not tested] to [tested YYYY-MM-DD] and note the evidence.
