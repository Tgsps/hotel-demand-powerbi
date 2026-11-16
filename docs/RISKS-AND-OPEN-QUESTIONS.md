# Risks and open questions

Status: planning document. Source IDs (Sxx) refer to docs/LEARN-SOURCES.md.

"Owner decision" = **Yes** means the work in the named phase should not go ahead until the owner decides. Where CC had to pick something to keep going, the "Conservative default" column says what it assumed.

## Risks and decisions

| ID | Item | Status | Conservative default | Owner decision | Blocks |
|---|---|---|---|---|---|
| R01 | **Dataset licence.** The licence of Hotel Booking Demand is not verified at the original source. Mirrors (Kaggle, TidyTuesday and others) may state their own terms, and those are not proof [not verified]. | Open | Do not commit the data. Do not publish screenshots or the repo publicly. Credit the authors in the README, with the licence marked "unverified". | **Yes**: read the terms at the publisher's page, record them in DATA-SOURCE.md, then decide whether the repo can be public. | Phase 0 (record), Phase 5 (publish) |
| R02 | **Power BI Service access.** Unknown. Sign-up needs a work or school account; consumer email domains cannot be used directly [verified: S41]. A Microsoft 365 trial creates one but needs a credit card [verified: S41]. Free licence: no sharing and no workspaces other than My workspace [verified: S39, S40]. | Open | Plan without the Service. 11 objectives are covered by the runbook only. | **Yes**: choose one: (a) no Service, (b) a trial tenant (cost and card), (c) an existing employer or school tenant, if its policy allows it. | Phase 4b |
| R03 | **File size and storage.** The CSV size is not verified. CC believes it is in the tens of MB [not verified]. GitHub file-size limits were not checked [not verified]. | Open | `data/` is git-ignored. Each user downloads the data themselves. | No (unless the owner wants to commit the data after R01) | none |
| R04 | **Local path leak via the parameter.** The `DataFolderPath` value will be saved in the PBIP model files (expressions) when the project is saved [inferred from S03, S07]. That puts a local path into git. | Open | Commit with a neutral placeholder value. The owner sets the real value locally and runs the check script (P0-03) before each commit. | **Yes**: choose one: (a) placeholder plus check script, (b) keep the data in a folder whose path has no personal information, (c) another approach. | Phase 1 commit |
| R05 | **Desktop build and PBIP features.** Automatic reload of external edits is in preview, needs the August 2026 release or later, and needs a preview switch [verified: S05]. S06 says a restart is needed. The pages conflict. Whether TMDL is the default format in the owner's build is not verified. | Open | CC edits TMDL only while Desktop is closed. The owner restarts Desktop after each CC edit. | No (Phase 0 records the version) | Phase 1-2 TMDL route |
| R06 | **TMDL written from scratch.** No Learn page says a whole model can be written as TMDL text and then opened [verified: absence across S02-S07]. External edits are supported but "may result in unexpected behavior" [verified: S02]. | Open | The owner creates the skeleton in Desktop first. CC only edits existing definition files, or supplies DAX query view scripts and M code to paste. | No | none |
| R07 | **USERELATIONSHIP with RLS.** It cannot be used when RLS is defined on the table holding the measure [verified: S23]. The RLS page says it may cause errors [verified: S33]. | Open | Measures go in `_Measures`. Test P4-03. Fallback: a separate 'Status Date' table. | No | Phase 4 |
| R08 | **Copilot objectives (3.1.3, 3.1.7, 3.1.8, 3.3.6).** They need paid F2+ or P1+ capacity [verified: S47]. | Accepted | Marked "Not covered" | No | none |
| R09 | **Sensitivity labels (4.2.6).** They need Purview / AIP licensing, Pro or PPU, and a tenant setting [verified: S44, S45]. They are not supported with PBIP [verified: S02]. | Accepted | Runbook text only | No | none |
| R10 | **Exam objective drift.** The study guide may change again before the owner takes the exam. The change log does not say what the "Minor" changes were [verified: S01]. | Open | Re-check in Phase 5 (P5-02) | No | none |
| R11 | **Weekly time budget unknown.** The estimates assume 6-8 hours a week. | Open | As stated | **Yes**: confirm the hours, or say which phases to cut (Phase 4b and the practice queries first). | Timeline |
| R12 | **adr outlier threshold.** The max of 5,400 [verified: planner brief] is assumed to be an error [not verified]. | Open | Keep the row, flag it, and offer a measure without it | **Yes**: choose the threshold after looking at the distribution (Phase 1) | P1-06 |
| R13 | **Country names.** The dataset has codes only [not verified]. Adding names needs an authoritative ISO list, and that list has its own licence. | Open | Show codes, with "Unknown" for UNK | **Yes**: whether to add names, and from which source | none |
| R14 | **Append source.** CC believes the original publication may provide two files (one per hotel) [not verified]. If so, objective 1.3.8 append is natural. If not, a practice split is needed. | Open | Practice append on a split, load disabled | **Yes**: which file(s) to download | P1-16 |
| R15 | **Field meanings.** These are taken from memory of the dataset paper [not verified]: the adr definition, is_canceled including no-shows, status date = cancel date for cancelled rows, lead_time in days, meal code descriptions. Measures M02, M04, M08, M19 and M26 depend on them. | Open | Measures are marked [not tested]. Phase 1 cross-tabs (DQ-15) check them. | No (the owner reads the paper in Phase 0) | Phase 2 |
| R16 | **Duplicate rows.** There is no booking ID, so identical rows may be distinct bookings [inferred]. | Open | Never deduplicate. Report the count only. | No | none |
| R17 | **Locale.** The owner's Windows regional format may parse "." decimals wrongly [verified as a general risk: S15]. | Mitigated | Culture "en-US" in every type conversion | No | none |
| R18 | **Partial years.** Arrivals cover 2015-2017 [verified: planner brief]. The first and last years are probably incomplete [not verified]. YoY at year level would mislead. | Open | YoY at month level, BLANK when either period is empty, and a note on the report | No | Phase 2-3 |
| R19 | **Automatic page refresh (3.2.13).** CC's belief that it does not apply to Import from a CSV is not verified. | Open | Marked "Not covered" pending a check | No | Phase 3 |
| R20 | **Map visuals.** Tenant or online requirements for the map and filled map visuals were not checked [not verified]. | Open | Use a bar chart by country if the maps are unavailable | No | Phase 3 |
| R21 | **Personal data.** The dataset is described as anonymised: no names, and agent and company are IDs only [not verified]. | Open | Screenshots show aggregates only. No raw rows in docs. | No | none |
| R22 | **Encoding and line endings.** Edited PBIP files must be UTF-8 without BOM. Desktop writes CRLF [verified: S02]. CC's tools could change either. | Open | `.gitattributes` (P0-02). CC checks the BOM and line endings after each edit. | No | Phase 1-2 |
| R23 | **Calendar-based time intelligence.** Preview, and recommended by the page [verified: S32]. | Accepted | Use classic (GA) time intelligence with a marked date table | No | none |
| R24 | **Learn pages not read.** See the gaps table in LEARN-SOURCES.md. Several Phase 3 and 4 claims rest on CC's memory. | Open | Those items are labelled [not verified]. Read each page before the phase that needs it. | No | Phase 3-4 |

## Ambiguities in the brief

| ID | Ambiguity | Assumption taken |
|---|---|---|
| A01 | "Create a new empty folder" did not say where. | Created `hotel-demand-powerbi` inside the session's working folder. It is a new folder with its own git repo, separate from any other project. |
| A02 | "Use its exact objectives as the coverage checklist" vs keeping quotes from Learn short. | The coverage table has one row per study-guide bullet (78), in guide order, with a condensed paraphrase of each. Anyone can line it up against the live guide. If the planner wants exact wording, the owner can paste it in from the guide. |
| A03 | "Week estimates" with no stated weekly hours. | 6-8 hours a week (R11). |
| A04 | "Covers the PL-300 skill areas": how deep for Service-only skills. | All four areas are planned. Service-only skills are covered by a runbook unless R02 allows real Service work. Each row of the coverage table says which. |
| A05 | "Do not create data files" (this task) vs the plan proposing a small JSON lookup (P1-15). | No data file was created now. P1-15 is a future task, and its content will come from the dataset paper once the owner verifies it. |
| A06 | Whether the PBIP should be created by CC as text or by the owner. | The owner creates it in Desktop first (R06). CC edits it afterwards. |
| A07 | "Label every factual claim" vs design decisions. | Decisions and proposals are not factual claims and carry no label. Facts about Power BI, the dataset or the exam are labelled. |
| A08 | The brief's figures are "verified by the planner". | Labelled [verified: planner brief]. CC did not re-check them, because the brief said not to run the dataset. |

## Decisions needed from the owner (summary)

1. R01: licence. Read the publisher's terms and decide whether the repo can be public.
2. R02: Service access: none, trial, or an existing tenant.
3. R04: how to keep the local data path out of git.
4. R11: weekly hours, or which phases to cut.
5. R12: adr outlier threshold (after Phase 1 profiling).
6. R13: whether to add country names, and from which source.
7. R14: which source file(s) to download (affects the append task).
