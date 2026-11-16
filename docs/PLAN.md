# Plan: Hotel Booking Demand, Power BI portfolio project (PL-300 coverage)

Status: planning only. Nothing has been built. Source IDs (Sxx) refer to docs/LEARN-SOURCES.md. Risks (Rxx) refer to docs/RISKS-AND-OPEN-QUESTIONS.md.

## Goal

A Power BI Desktop project (PBIP, kept in git) built on the Hotel Booking Demand dataset. It shows the PL-300 skills a junior data analyst is expected to have:
- data preparation in Power Query,
- a star-schema model,
- DAX measures,
- a multi-page report,
- row-level security.

Skills that need the Power BI Service are covered only if the owner gets Service access (R02). Otherwise they are documented as runbooks and marked as such in the coverage table.

## Roles

- **CC (Claude Code)** writes text only:
  - Power Query M,
  - DAX scripts,
  - TMDL edits once a project exists,
  - theme JSON,
  - docs,
  - check scripts.
  CC does not run Power BI and cannot see visuals.
- **Owner** does everything inside Power BI Desktop or the Service. That includes downloading the data and confirming the licence. The owner also records the observed numbers back into the docs.

## Assumptions

1. The owner has about 6-8 hours a week. The week estimates depend on this (R11).
2. Desktop is a recent build. Check it in Phase 0 (R05).
3. The owner has Power BI (free) under Microsoft Fabric (Free), with no Pro or PPU (R02). The target is Desktop + My workspace. P0-09 tests what that allows. Phase 4b is limited to what P0-09 confirms.
4. Data files are never committed until the licence is verified, and probably not even then (R01, R03).

## Timeline

| Phase | Content | Estimate |
|---|---|---|
| 0 | Setup, licence and access checks | 0.5 week |
| 1 | Prepare the data (Power Query) | 1.5 weeks |
| 2 | Model and DAX | 1.5 weeks |
| 3 | Report pages and analysis | 2 weeks |
| 4a | Security in Desktop, plus Service runbooks | 0.5-1 week |
| 4b | Service work (only if access) | 0.5-1 week |
| 5 | Packaging for the CV | 0.5 week |
| | **Total** | **about 6.5-8 weeks** |

## Milestones

Each milestone has to be usable on its own, even if the later phases never happen.

| Milestone | After | Content | Release |
|---|---|---|---|
| M1 | Phase 2 | README with the model diagram and the measures list (name, business question, tested status). The PBIP project opens in Desktop after the data path parameter is set. | First release |
| M2 | Phase 3 | Screenshots of the report pages, showing aggregates only, with attribution (R01). The README is updated with findings taken from the report. | Second release |

Phases 4 and 5 add to M2 but are not needed for it.

---

## Phase 0: Setup, licence and access (0.5 week)

### Acceptance checks (written before the work)

- A0.1 `git ls-files` lists no `.csv`, `.pbix`, `cache.abf` or `localSettings.json`.
- A0.2 `.gitignore` excludes `data/`, `**/.pbi/localSettings.json` and `**/.pbi/cache.abf`. The last two are the patterns Desktop itself would write [verified: S02].
- A0.3 `docs/DATA-SOURCE.md` records:
  - the file provenance (the TidyTuesday copy),
  - the outcome of the licence check at the original source (verified, or still unverified and why),
  - the file size,
  - the SHA-256 hash,
  - row count 119,390 and column count 32.
  It contains no local path.
- A0.4 The Desktop version (month and year) and install type (Store or .exe) are recorded. The file also says whether the preview option "Detect and reload external PBIP changes" exists [verified: S05 names this option]. Recorded 2026-11-16: the option exists and is enabled [verified: owner, 2026-11-16]. The rule "CC edits TMDL only while Desktop is closed" stays until the reload behaviour is tested in Phase 1 (R05).
- A0.5 The owner's decisions on R01 (licence) and R02 (Service) are written into RISKS-AND-OPEN-QUESTIONS.md.
- A0.6 The local-path check script runs and passes on the repo.
- A0.7 The P0-09 results are recorded in `docs/SERVICE-RUNBOOK.md` for exactly these items: 4.1.3 publish to My workspace, 4.1.4 dashboard and pin, 4.1.6 data alert on a tile (and whether subscriptions appear at all), 4.1.9 scheduled refresh for a local CSV, and 4.2.5. Each one is marked "works", "does not work", "blocked by a tenant setting" or "not tried", with the date.
- A0.8 `.gitignore` is on origin/main before any data file is placed inside the clone. `git log origin/main -- .gitignore` shows a commit dated before the first use of `data/`.

### Tasks

**Order:** P0-02 comes first. It is committed and pushed (with owner approval) before the owner places any data file inside the clone. The other tasks follow in ID order.

| ID | Task | Who |
|---|---|---|
| P0-02 | **First.** Write `.gitignore` (data/, PBIP cache and local settings) and `.gitattributes`. Edited PBIP files must be UTF-8 without BOM, and Desktop writes CRLF [verified: S02]. Set `*.tmdl`, `*.pbir`, `*.pbism` and `*.json` to `text eol=crlf`. Push only with owner approval, before any data file is in the clone. | CC, owner approves the push |
| P0-01 | Write README.md skeleton: purpose, attribution with the wording in R01, licence status, how to open the project<br>**Status: done 2026-11-16.** Planner wrote it; CC reviewed it against the honesty rules (FROM-PLANNER-04). | CC |
| P0-03 | Write `scripts/check-no-local-paths.ps1`. It fails if any tracked text file contains a drive-letter path, a user-profile folder name or an email-like string.<br>**Status: done 2026-11-16.** Planner wrote it, and it also checks for byte-order marks. CC ran it in Windows PowerShell 5.1 and it passed; the patterns were tested on sample strings. It reads tracked files only, so new files must be staged first. | CC |
| P0-04 | Write the `docs/DATA-SOURCE.md` template<br>**Status: done 2026-11-16.** Filled in, not just a template (FROM-PLANNER-03). | CC |
| P0-05 | Record the file provenance as the TidyTuesday copy. The original article is identified. The article is published under CC BY 4.0, and the data files are supplied with it [verified: planner, source paper]. The file's licence is inferred from the article licence [inferred] (wording as in R01). Confirm the exact wording at the source and record the outcome in DATA-SOURCE.md. Keep the file in `data/` (ignored by git), and only after P0-02 is on origin/main. | Owner |
| P0-06 | Compute the hash (`Get-FileHash -Algorithm SHA256`) and the size. Record them. | Owner |
| P0-07 | Record the Desktop version and preview options. Turn off auto date/time for new files (Options > Global > Data load) if the owner agrees [verified: S20 location]. | Owner |
| P0-08 | Decide on R01, R02 and R04 | Owner |
| P0-09 | Publish a test report from Desktop to My workspace with the Free licence. Test only these and record exactly what works and what does not:<br>- 4.1.3 publish to My workspace<br>- 4.1.4 create a dashboard and pin<br>- 4.1.6 a data alert on a tile; subscriptions need qualifying capacity [verified: S46], so this row is at most Partial<br>- 4.1.9 scheduled refresh; a local CSV needs a gateway [inferred: S48]<br>- 4.2.5 RLS membership [not verified]<br>Record any block caused by a tenant admin setting [verified: S46 says settings can disable features]. Until this is done, those 5 rows are labelled "Service-only [pending P0-09]". | Owner |

---

## Phase 1: Prepare the data (1.5 weeks)

### Acceptance checks

- A1.1 FactBooking has 119,390 rows after all steps. No step removes rows (DATA-QUALITY principle 1).
- A1.2 "Keep errors" returns 0 rows on every loaded query.
- A1.3 Agent nulls = 16,340. Company nulls = 112,593. Country `UNK` = 488; the source holds the text "NULL" in these rows [verified: planner, direct read 2026-11-16]. IsAdrNegative = 1. IsAdrZero = 1,959. All per [verified: planner brief].
- A1.4 City Hotel = 79,330 and Resort Hotel = 40,060. Cancellation rate rounds to 37.0%.
- A1.5 'Date' covers whole calendar years with no gaps. It can be marked as a date table without a validation error [verified: S19 lists the validation].
- A1.6 Only these tables load: FactBooking, Hotel, Date, the small dimensions, and AggBookingsMonth if used. Staging, practice and lookup queries have load disabled.
- A1.7 The privacy level of the CSV source is set and recorded. No Formula.Firewall error appears.
- A1.8 Profiling ran on the entire data set [verified: S16]. DATA-QUALITY.md has observed numbers in place of "to verify".
- A1.9 The project is saved as PBIP. The `.SemanticModel/definition/` folder exists, which means TMDL storage [verified: S03]. The local-path check passes. The folder parameter value is not committed (R04).

### Tasks

| ID | Task | Who | PL-300 |
|---|---|---|---|
| P1-01 | Parameter `DataFolderPath` (text). Source step: `Csv.Document(File.Contents(DataFolderPath & "hotels.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv])` [verified: S08 options; parameter in path not verified, S17]. | CC writes, owner creates | 1.1.1, 1.1.4 |
| P1-02 | Connect in Desktop with Get data > Text/CSV, then switch the step to the parameter. | Owner | 1.1.1 |
| P1-03 | Set the privacy level on the file source in Data source settings > Edit permissions [verified: S36]. Record the choice and the reason. Show once how changing the source path is done through the parameter. | Owner | 1.1.2 |
| P1-04 | Decision record `docs/decisions/storage-mode.md`: Import vs DirectQuery vs Direct Lake, and why Import [inferred reasoning; Learn page not read]. | CC | 1.1.3 |
| P1-05 | Profiling on the entire data set. Record the stats in DATA-QUALITY.md. | Owner | 1.2.1 |
| P1-06 | Staging query `stg_Bookings` with the cleaning rules DQ-01 to DQ-06 and the confirmed DQ-07 to DQ-16. | CC writes M, owner applies | 1.2.2, 1.3.1 |
| P1-07 | Import-error drill: once, convert adr with the wrong culture, observe the errors, then fix it with culture "en-US" [verified: S10, S15]. Record it with screenshots. Show Table.ReplaceErrorValues on a practice query [verified: S11]. | Owner, CC gives the steps | 1.2.3 |
| P1-08 | Explicit types for every column, with culture "en-US" | CC | 1.3.1 |
| P1-09 | Derived columns: ArrivalDate, BookingDate, StatusDate, DepartureDate, TotalNights, TotalGuests, flags (DATA-QUALITY "Derived columns") [S13, S14 verified] | CC | 1.3.2 |
| P1-10 | Fact and dimension queries. Dimensions are **reference** queries of the staging query. Write a note on reference vs duplicate in `docs/decisions/reference-vs-duplicate.md`. | CC | 1.3.6, 1.3.7 |
| P1-11 | Keys: BookingKey (index), HotelKey (merge with Hotel), natural codes for the other dimensions | CC | 1.3.9 |
| P1-12 | Turn off load on staging, practice and lookup queries. Turn off "include in report refresh" where it makes sense. | Owner | 1.3.10 |
| P1-13 | Group By query AggBookingsMonth | CC | 1.3.3 |
| P1-14 | Practice queries (load disabled): unpivot WeekendNights/WeekNights into NightType; a monthly pivot by hotel; a transpose of a small summary. Function pages still to be read (LEARN-SOURCES gaps). | CC | 1.3.4 |
| P1-15 | `data/lookup/meal.json`, a small JSON lookup of meal codes. The descriptions must be taken from the dataset paper, and the owner verifies them. Parse it with Json.Document, turn it into a table, and merge it into the Meal dimension. | CC writes after the owner confirms the descriptions | 1.3.5, 1.3.8 |
| P1-16 | Append. The original article provides two datasets (H1 Resort, H2 City, 31 variables each) [verified: planner, source paper]. If the owner obtains them, load both and append them for real. Otherwise, append a practice split of the merged file. Owner decision R14 (pending). | CC / Owner | 1.3.8 |
| P1-17 | 'Date' query in Power Query, with the range computed from the fact dates (DATA-MODEL.md) | CC | 2.1.4 |
| P1-18 | Save as PBIP (TMDL). Commit after the local-path check. | Owner | (enabler) |

---

## Phase 2: Model and DAX (1.5 weeks)

### Acceptance checks

- A2.1 The relationships match DATA-MODEL.md R1-R11 exactly: *:1, single direction, R3 inactive. There are no ambiguity warnings.
- A2.2 Auto date/time is off for this file [verified: S20]. 'Date' is marked as a date table.
- A2.3 Every measure in MEASURES.md has been run in DAX query view against an independent figure. Its label has changed from [not tested] to [tested date] with evidence. Measures that fail are fixed or removed.
- A2.4 Properties are set as listed in DATA-MODEL.md: hidden keys, sort-by-column, formats, summarizeBy, descriptions, folders.
- A2.5 The TimeCalc calculation group gives the same PY and YTD as M21 and M23 for [Bookings].
- A2.6 One Performance Analyzer log is exported and summarised in `docs/perf/README.md` [verified: S52 export], with at least one finding acted on.
- A2.7 The detail vs AggBookingsMonth comparison is documented with numbers (visual time, and model size if available).

### Tasks

| ID | Task | Who | PL-300 |
|---|---|---|---|
| P2-01 | Create relationships R1-R11. Once the PBIP exists, CC can write them in `relationships.tmdl`; otherwise the owner creates them in Model view. | CC / Owner | 2.1.3 |
| P2-02 | Mark 'Date' as the date table. Turn off auto date/time for the current file. | Owner | 2.1.4 |
| P2-03 | Calculated table 'Booking Date' = 'Date'. Set sort and format again, because the clone does not copy them [verified: S18]. Rename the columns. | CC (DAX), owner (properties) | 2.1.2, 2.1.5, 2.2.7 |
| P2-04 | Inactive relationship R3 and measure M19 | CC | 2.1.2, 2.2.2 |
| P2-05 | Table and column properties | Owner, CC lists them | 2.1.1 |
| P2-06 | Write `docs/decisions/calculated-columns-vs-measures.md`: which columns are computed in Power Query and why, the one calculated table, and when a calculated column would be right. Add one calculated column as an example (for example `LeadTimeBand`), and compare it with a Power Query column. | CC | 2.1.5, 2.2.7 |
| P2-07 | Measures M01-M28 through a DAX query view script [verified: S53] | CC writes, owner applies | 2.2.1-2.2.5 |
| P2-08 | Quick measure Q01. Record the generated DAX. | Owner | 2.2.6 |
| P2-09 | Calculation group TimeCalc C01-C04 (Model view or TMDL view) [verified: S50] | CC writes, owner applies | 2.2.8 |
| P2-10 | Performance Analyzer on the Overview page. Copy the slowest query into DAX query view [verified: S52]. Note the findings. | Owner | 2.3.2 |
| P2-11 | Detail vs aggregated table comparison. Remove unneeded columns (week number, raw columns not used) and record the effect. | Owner, CC prepares | 2.3.1, 2.3.3 |

---

## Phase 3: Report and analysis (2 weeks)

### Acceptance checks

- A3.1 These pages exist:
  - Overview
  - Cancellations
  - Booking Window
  - Revenue & ADR
  - Markets & Channels
  - Insights
  - Segment Detail (drillthrough, hidden)
  - Tooltip (hidden)
- A3.2 The custom theme JSON from the repo is applied. Text and background contrast is checked with a contrast tool. Each value is recorded.
- A3.3 Every visual has a title and alt text. The tab order is set on every page.
- A3.4 Navigation (buttons or a page navigator), at least two bookmarks, a drillthrough from Overview to Segment Detail, and a tooltip page all work. A short screen recording or screenshots prove it.
- A3.5 Hotel and year slicers are synced across the main pages. Visual interactions are edited on at least one page.
- A3.6 The Overview page has a mobile layout.
- A3.7 The Insights page has:
  - Key influencers on IsCanceled,
  - a decomposition tree,
  - lead-time bins and one clustering,
  - a reference line and error bars,
  - a forecast on monthly bookings,
  - anomaly detection on one line.
  The page states the data limits (partial years).
- A3.8 Screenshots are exported to `docs/img/`. They show aggregates only, no row-level detail.

### Tasks

| ID | Task | Who | PL-300 |
|---|---|---|---|
| P3-01 | Report spec `docs/REPORT-SPEC.md`: page by page, the business question, the visual type and why, the fields, and the measures | CC | 3.1.1 |
| P3-02 | Theme JSON `theme/hotel-theme.json` (colours, fonts, visual defaults) | CC writes, owner applies | 3.1.4 |
| P3-03 | Build the pages per the spec. Format the visuals. Set the page settings: size, background, canvas. | Owner | 3.1.1, 3.1.2, 3.1.9 |
| P3-04 | Conditional formatting: cancellation rate colours, data bars on ADR | Owner | 3.1.5 |
| P3-05 | Slicers and filters on visual, page and report level | Owner | 3.1.6 |
| P3-06 | Visual calculations V01 and V02 [verified: S51] | Owner | 3.1.11 |
| P3-07 | Bookmarks, navigation, selection pane groups and layering | Owner | 3.2.1, 3.2.4, 3.2.7 |
| P3-08 | Custom tooltip page. Drillthrough page with a back button. | Owner | 3.2.2, 3.2.8 |
| P3-09 | Edit interactions, sorting, sync slicers | Owner | 3.2.3, 3.2.5, 3.2.6 |
| P3-10 | Export data settings and personalization setting. Desktop sets them; the effect is visible only in the Service [not verified]. | Owner | 3.2.9, 3.2.11 |
| P3-11 | Mobile layout and accessibility (alt text, tab order, contrast, no meaning carried by colour alone) | Owner, CC writes the checklist | 3.2.10, 3.2.12 |
| P3-12 | Decision note: when a paginated report would be right, for example a printable monthly booking list. No paginated report is built. | CC | 3.1.10 |
| P3-13 | Analyze ("explain the increase/decrease"), grouping, binning, clustering, AI visuals | Owner | 3.3.1-3.3.3 |
| P3-14 | Reference lines, error bars, forecasting, outlier and anomaly detection (adr outlier DQ-06) | Owner | 3.3.4, 3.3.5 |

---

## Phase 4a: Security in Desktop and Service runbooks (0.5-1 week)

### Acceptance checks

- A4.1 Two static roles exist, `City Hotel` and `Resort Hotel`, each a DAX filter on Hotel[HotelName] [verified: S33 Manage roles]. With "View as" each role, the counts match the A1.4 hotel split.
- A4.2 M19 returns a value under both roles. If not, the fallback in DATA-MODEL.md is applied and the result is recorded (P4-03).
- A4.3 `docs/SERVICE-RUNBOOK.md` exists and covers every Service-only objective. For each one it gives the steps, the licence needed (with a source ID), and what was or was not done.
- A4.4 No real identity (email, UPN, name) appears anywhere in the repo.

### Tasks

| ID | Task | Who | PL-300 |
|---|---|---|---|
| P4-01 | Write the role definitions (TMDL `roles/` or a step-by-step list for Manage roles) | CC | 4.2.4 |
| P4-02 | Create the roles in Desktop and test them with View as [verified: S34] | Owner | 4.2.4 |
| P4-03 | Test USERELATIONSHIP (M19) under RLS [verified risk: S23, S33]. Apply the fallback if needed. | Owner | 4.2.4 |
| P4-04 | Optional: a dynamic RLS demo with USERPRINCIPALNAME() and a mapping table. The mapping values are typed in Desktop with "Enter data" using made-up values and are **not committed**. In Desktop, USERNAME() returns DOMAIN\user [verified: S33]. | Owner, optional | 4.2.4 |
| P4-05 | SERVICE-RUNBOOK.md: workspace and roles, app, publish and update, dashboard, distribution choice, subscriptions and alerts, endorsement, gateway decision, scheduled refresh, item access, semantic model access, RLS membership, sensitivity labels. | CC | 4.1.x, 4.2.x |

Gateway reasoning for the runbook: the CSV sits on a local disk, so a scheduled refresh in the Service would need a gateway, because the Service cannot reach the file over the internet [inferred from S48]. Pro allows up to 8 scheduled refreshes a day [verified: S49].

## Phase 4b: Service (optional, limited to what P0-09 confirms for Free + My workspace)

With the owner's Free licence, tasks that need a shared workspace, an app or other users can only be done if a later licence change allows it (R02). Workspace roles, apps and item access, for example, need Pro or PPU [verified: S40, S46].

### Acceptance checks

- A4b.1 The report is published to My workspace (Free licence). Publishing to any other workspace needs Pro or PPU [verified: S40, S54].
- A4b.2 Only if P0-09 shows that 4.2.5 is possible: RLS members are assigned on the semantic model Security page and tested with "Test as role" [verified: S33].
- A4b.3 Screenshots of each step taken. The runbook marks each step "done in Service" with the date.
- A4b.4 Publish to web is **not** used unless the owner decides it and the licence is verified. It makes the report public [verified: S42].

### Tasks

| ID | Task | PL-300 |
|---|---|---|
| P4b-01 | Dropped with Free: creating a workspace and assigning roles is not possible [verified: S46]. Runbook text only. | 4.1.1, 4.2.1 |
| P4b-02 | Publish from Desktop to My workspace. Update it once. | 4.1.3 |
| P4b-03 | Dropped with Free: a free user cannot create an app [verified: S46]. Runbook text only. | 4.1.2 |
| P4b-04 | Create a dashboard in My workspace and pin visuals | 4.1.4 |
| P4b-05 | One data alert on a dashboard tile. Record whether subscriptions are offered at all; they are listed only on qualifying capacity [verified: S46]. | 4.1.6 |
| P4b-06 | Dropped with Free: a free user cannot add endorsements [verified: S46]. Runbook text only. | 4.1.7 |
| P4b-07 | Gateway decision, and scheduled refresh if a gateway or cloud storage is set up. Schedule refresh is listed for My workspace [verified: S46]. A local CSV needs a gateway [inferred: S48]. | 4.1.8, 4.1.9 |
| P4b-08 | Dropped with Free: sharing and managing permissions are not possible [verified: S46]. Runbook text only. | 4.2.2, 4.2.3 |
| P4b-09 | RLS role membership, only if P0-09 shows it is possible [not verified] | 4.2.5 |

---

## Phase 5: Packaging (0.5 week)

### Acceptance checks

- A5.1 The README has the business questions, findings (3-5 bullets with numbers taken from the report), screenshots, the model diagram, the coverage summary, attribution and the licence status.
- A5.2 The licence has been re-checked (R01). Whether the repo can be public has been decided by the owner.
- A5.3 The PL-300 study guide has been re-read. Any changes to the objectives are reflected in the coverage table, with the date checked.
- A5.4 The local-path check passes. A clone of the repo opens in Desktop after the owner points the parameter at their own data folder.

### Tasks

| ID | Task | Who |
|---|---|---|
| P5-01 | Final README, CV bullet text (facts only, no claimed results that were not measured) | CC drafts, owner approves |
| P5-02 | Re-check the study guide and update the coverage table | CC |
| P5-03 | Decide on a public remote. Push only if the owner decides to (outside the scope of this plan). | Owner |

---

## PL-300 coverage table

The objective labels below are condensed paraphrases, numbered in the order of the study guide [verified: S01, skills as of 20 April 2026, 78 bullets]. Use the guide itself for the exact wording.

Coverage values:
- **Desktop** = done in Desktop by this project.
- **Partial** = only part of the objective is done.
- **Service-only [pending P0-09]** = needs the Service, and may be possible in My workspace with the Free licence. P0-09 tests it.
- **Not covered (Free)** = needs Pro or PPU, which the owner does not have (R02). Runbook text only.
- **Not covered** = cannot be done, with the reason.

### 1 Prepare the data (25-30%)

| # | Objective (condensed) | Task(s) | Coverage |
|---|---|---|---|
| 1.1.1 | Connect to data sources or a shared semantic model | P1-01, P1-02 | Partial: CSV source in Desktop. A shared semantic model needs the Service. |
| 1.1.2 | Change source settings, credentials, privacy levels | P1-03 | Desktop (file source has no credentials) |
| 1.1.3 | Choose Direct Lake, DirectQuery or Import | P1-04 | Partial: written decision only. Only Import is possible with a CSV [inferred]. |
| 1.1.4 | Create and modify parameters | P1-01 | Desktop |
| 1.2.1 | Evaluate data statistics and column properties | P1-05 | Desktop |
| 1.2.2 | Resolve inconsistencies, nulls, quality issues | P1-06 | Desktop |
| 1.2.3 | Resolve import errors | P1-07 | Desktop |
| 1.3.1 | Select column data types | P1-08 | Desktop |
| 1.3.2 | Create and transform columns | P1-09 | Desktop |
| 1.3.3 | Group and aggregate rows | P1-13 | Desktop |
| 1.3.4 | Pivot, unpivot, transpose | P1-14 | Desktop (practice queries) |
| 1.3.5 | Semi-structured data to a table | P1-15 | Desktop (small JSON lookup) |
| 1.3.6 | Create fact and dimension tables | P1-10 | Desktop |
| 1.3.7 | Reference vs duplicate queries | P1-10 | Desktop and a written note |
| 1.3.8 | Merge and append | P1-15, P1-16 | Desktop (append depends on R14) |
| 1.3.9 | Keys for relationships | P1-11 | Desktop |
| 1.3.10 | Configure data loading | P1-12 | Desktop |

### 2 Model the data (25-30%)

| # | Objective (condensed) | Task(s) | Coverage |
|---|---|---|---|
| 2.1.1 | Table and column properties | P2-05 | Desktop |
| 2.1.2 | Role-playing dimensions | P2-03, P2-04 | Desktop (both patterns) |
| 2.1.3 | Cardinality and cross-filter direction | P2-01 | Desktop |
| 2.1.4 | Common date table | P1-17, P2-02 | Desktop |
| 2.1.5 | Use cases for calculated columns and tables | P2-03, P2-06 | Desktop and a written note |
| 2.2.1 | Single aggregation measures | P2-07 (M01, M06, M12) | Desktop |
| 2.2.2 | CALCULATE | P2-07 (M02, M05, M08, M19) | Desktop |
| 2.2.3 | Time intelligence measures | P2-07 (M21-M24, M27-M28) | Desktop |
| 2.2.4 | Basic statistical functions | P2-07 (M13-M15) | Desktop |
| 2.2.5 | Semi-additive measures | P2-07 (M26) | Desktop |
| 2.2.6 | Quick measures | P2-08 | Desktop |
| 2.2.7 | Calculated tables or columns | P2-03, P2-06 | Desktop |
| 2.2.8 | Calculation groups | P2-09 | Desktop |
| 2.3.1 | Remove unnecessary rows and columns | P2-11 | Desktop |
| 2.3.2 | Performance Analyzer and DAX query view | P2-10 | Desktop |
| 2.3.3 | Reduce granularity | P2-11, P1-13 | Desktop |

### 3 Visualize and analyze the data (25-30%)

| # | Objective (condensed) | Task(s) | Coverage |
|---|---|---|---|
| 3.1.1 | Select an appropriate visual | P3-01, P3-03 | Desktop |
| 3.1.2 | Format and configure visuals | P3-03 | Desktop |
| 3.1.3 | Narrative visual with Copilot | none | Not covered: Copilot needs paid F2+ or P1+ capacity. Pro, PPU and trial capacity are not enough [verified: S47]. |
| 3.1.4 | Apply and customize a theme | P3-02 | Desktop |
| 3.1.5 | Conditional formatting | P3-04 | Desktop |
| 3.1.6 | Slicing and filtering | P3-05 | Desktop |
| 3.1.7 | Copilot: new report page | none | Not covered (as 3.1.3) |
| 3.1.8 | Copilot: suggest page content | none | Not covered (as 3.1.3) |
| 3.1.9 | Configure the report page | P3-03 | Desktop |
| 3.1.10 | When to use a paginated report | P3-12 | Partial: written decision only |
| 3.1.11 | Visual calculations | P3-06 | Desktop |
| 3.2.1 | Bookmarks | P3-07 | Desktop |
| 3.2.2 | Custom tooltips | P3-08 | Desktop |
| 3.2.3 | Edit interactions | P3-09 | Desktop |
| 3.2.4 | Report navigation | P3-07 | Desktop |
| 3.2.5 | Sorting | P3-09 | Desktop |
| 3.2.6 | Sync slicers | P3-09 | Desktop |
| 3.2.7 | Selection pane, grouping and layering | P3-07 | Desktop |
| 3.2.8 | Drillthrough with pages, filters, buttons | P3-08 | Desktop |
| 3.2.9 | Export settings | P3-10 | Desktop (setting). The effect can only be shown in the Service. |
| 3.2.10 | Mobile design | P3-11 | Desktop |
| 3.2.11 | Personalization | P3-10 | Partial: setting in Desktop. Using it needs the Service [not verified]. |
| 3.2.12 | Accessibility | P3-11 | Desktop |
| 3.2.13 | Automatic page refresh | none | Not covered: CC believes it needs DirectQuery or a similar source, and this model is Import from a CSV [not verified; read the Learn page before final marking]. |
| 3.3.1 | Analyze feature | P3-13 | Desktop |
| 3.3.2 | Grouping, binning, clustering | P3-13 | Desktop |
| 3.3.3 | AI visuals | P3-13 | Desktop |
| 3.3.4 | Reference lines, error bars, forecasting | P3-14 | Desktop |
| 3.3.5 | Outliers and anomalies | P3-14 | Desktop |
| 3.3.6 | Copilot: summarize the semantic model | none | Not covered (as 3.1.3) |

### 4 Manage and secure Power BI (15-20%)

| # | Objective (condensed) | Task(s) | Coverage |
|---|---|---|---|
| 4.1.1 | Create and configure a workspace | P4-05, P4b-01 | Not covered (Free): a free user cannot create, edit or delete a workspace [verified: S46]. Runbook text only. |
| 4.1.2 | Configure and update an app | P4-05, P4b-03 | Not covered (Free): a free user cannot create an app [verified: S46]. Runbook text only. |
| 4.1.3 | Publish, import, update items | P4-05, P4b-02 | Service-only [pending P0-09]: publish to My workspace |
| 4.1.4 | Dashboards | P4-05, P4b-04 | Service-only [pending P0-09]: create a dashboard and pin, listed for My workspace [verified: S46] |
| 4.1.5 | Choose a distribution method | P4-05 | Partial: a written comparison is possible without the Service |
| 4.1.6 | Subscriptions and data alerts | P4-05, P4b-05 | Service-only [pending P0-09]: data alert on a tile. At most Partial, because subscriptions are listed only on qualifying capacity [verified: S46]. |
| 4.1.7 | Promote or certify content | P4-05, P4b-06 | Not covered (Free): a free user cannot add endorsements [verified: S46]. Runbook text only. |
| 4.1.8 | When a gateway is required | P4-05 | Partial: written decision [inferred from S48] |
| 4.1.9 | Scheduled refresh | P4-05, P4b-07 | Service-only [pending P0-09]: schedule refresh is listed for My workspace [verified: S46]. A local CSV needs a gateway [inferred: S48]. |
| 4.2.1 | Workspace roles | P4-05, P4b-01 | Not covered (Free): no workspace other than My workspace, and roles other than Viewer need Pro or PPU [verified: S46]. Runbook text only. |
| 4.2.2 | Item-level access | P4-05, P4b-08 | Not covered (Free): a free user cannot share or manage permissions [verified: S46, S54]. Runbook text only. |
| 4.2.3 | Access to semantic models | P4-05, P4b-08 | Not covered (Free): a free user cannot share a semantic model or manage permissions [verified: S46]. Runbook text only. |
| 4.2.4 | RLS roles | P4-01 to P4-04 | Desktop |
| 4.2.5 | RLS group membership | P4-05, P4b-09 | Service-only [pending P0-09] [not verified for Free]. Members are assigned in the Service [verified: S33]. |
| 4.2.6 | Sensitivity labels | P4-05 | Not covered: needs Purview / AIP P1 or P2 plus Pro or PPU and a tenant setting [verified: S44, S45]. Also, labels are not supported with PBIP [verified: S02]. Runbook text only. |

### Coverage summary

These counts come from the table above [inferred: counted by CC].

| Area | Bullets | Desktop | Partial | Service only | Not covered |
|---|---|---|---|---|---|
| 1 Prepare | 17 | 15 | 2 | 0 | 0 |
| 2 Model | 16 | 16 | 0 | 0 | 0 |
| 3 Visualize | 30 | 23 | 2 | 0 | 5 |
| 4 Manage | 15 | 1 | 2 | 5 | 7 |
| **Total** | **78** | **55** | **6** | **5** | **12** |

- Partial in area 3: 3.1.10 and 3.2.11. 3.2.9 is counted as Desktop.
- Not covered in area 3: 3.1.3, 3.1.7, 3.1.8, 3.2.13 and 3.3.6.
- Not covered in area 4: 4.1.1, 4.1.2, 4.1.7, 4.2.1, 4.2.2 and 4.2.3, because of the Free licence [verified: S46, S54]. 4.2.6 is not covered because of labels licensing and PBIP.
- Service-only in area 4 (pending P0-09): 4.1.3, 4.1.4, 4.1.6 (at most Partial), 4.1.9 and 4.2.5.
- Recounted on 2026-11-16 after FROM-PLANNER-02. Previous totals were 55 / 6 / 11 / 6.
