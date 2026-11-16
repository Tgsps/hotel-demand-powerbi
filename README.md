# Hotel Demand Analytics (Power BI)

A Power BI Desktop portfolio project built on the Hotel Booking Demand dataset. It is a project covering PL-300 skill areas: data preparation, modelling, DAX, reporting, and security. It is not equivalent to the certification.

**Status: planning stage.** No report, model or measure exists in this repository yet. What exists:
- the plan, the proposed model and the open decisions, in `docs/`;
- draft Power Query scripts for the first data-preparation step, in `src/m/`. They are marked "not tested" and have not been run in Power BI Desktop.

## Data

- The data is historical: bookings with arrival dates from 1 July 2015 to 31 August 2017, as described in the dataset article. It is not current data.
- The data file is **not** in this repository and is never committed. Each user places their own copy at `data/hotels.csv` inside the clone. Git ignores it.
- Provenance and file facts (size, SHA-256, row and column counts) are in `docs/DATA-SOURCE.md`.

## Attribution and licence

Dataset: Antonio, N., de Almeida, A., Nunes, L. (2019). "Hotel booking demand datasets". Data in Brief 22:41-49. doi 10.1016/j.dib.2018.11.126.

Licence status: article published under CC BY 4.0; the data files are supplied with the article; their licence is inferred from the article licence. The exact wording is still to be confirmed at the source (see `docs/RISKS-AND-OPEN-QUESTIONS.md`, R01).

## Scope

The plan covers the four PL-300 skill areas. With a free Power BI licence (Desktop plus My workspace), some Power BI Service objectives cannot be done. Those are recorded as "not covered", not simulated. The coverage table is in `docs/PLAN.md`.

## How to open the project

There is no Power BI project file yet. It is planned for Phase 1 of the plan. Until then, `src/m/README.md` explains how to paste the draft queries into Power BI Desktop.

When the project file exists:

1. Clone the repository.
2. Put your own copy of `hotels.csv` in the `data/` folder of the clone.
3. Open the project in Power BI Desktop and set the `DataFolderPath` parameter to the folder that holds `hotels.csv`.

How the parameter value is kept out of the repository is still an open decision (R04 in `docs/RISKS-AND-OPEN-QUESTIONS.md`). The proposed default is a neutral placeholder plus the check script below.

## Checks before a commit

Run `scripts/check-no-local-paths.ps1` from the repository. It fails if a tracked text file contains a drive-letter path, a user-profile folder name, an email-like string, or a byte-order mark. It only reads tracked files, so stage new files (`git add`) before running it.

## Documents

| File | Content |
|---|---|
| `docs/PLAN.md` | Phases, acceptance checks, PL-300 coverage table |
| `docs/DATA-MODEL.md` | Proposed star schema |
| `docs/DATA-QUALITY.md` | Data profile facts and cleaning rules |
| `docs/DATA-SOURCE.md` | Provenance, licence wording, file facts |
| `docs/MEASURES.md` | Candidate DAX measures (not tested) |
| `docs/RISKS-AND-OPEN-QUESTIONS.md` | Risks and owner decisions |
| `docs/LEARN-SOURCES.md` | Microsoft Learn sources used |
| `src/m/` | Draft Power Query M for Phase 1 (not tested) |
| `scripts/check-no-local-paths.ps1` | Pre-commit check for local paths, emails and byte-order marks |
| `handoff/` | Messages between the planner and Claude Code |
