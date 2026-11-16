# Data source

Status: filled in from FROM-PLANNER-03 (2026-11-16). This is task P0-04 and it covers check A0.3. Source IDs and labels are explained in docs/LEARN-SOURCES.md.

The data file is never committed. Each user places their own copy in `data/` inside the clone. `.gitignore` ignores it.

## Provenance

| Item | Value | Label |
|---|---|---|
| File used | `hotels.csv`, the merged TidyTuesday copy of Hotel Booking Demand | [verified: planner, direct read 2026-11-16] |
| Original article | Antonio, N., de Almeida, A., Nunes, L. (2019). "Hotel booking demand datasets". Data in Brief 22:41-49. doi 10.1016/j.dib.2018.11.126 | [verified: planner, source paper] |
| Original datasets | Two files in the article: H1 Resort Hotel (40,060 rows) and H2 City Hotel (79,330 rows), 31 variables each | [verified: planner, source paper] |
| Merged copy equals the originals | Not checked | [not verified] (R14) |

## Licence

Wording to use, as in R01:

> Article published under CC BY 4.0; the data files are supplied with the article; their licence is inferred from the article licence.

| Item | Value | Label |
|---|---|---|
| Article licence | CC BY 4.0 | [verified: planner, source paper; owner to confirm exact wording] |
| Data files supplied with the article | Yes | [verified: planner, source paper] |
| Licence of the data files | Same as the article | [inferred] |
| Terms stated by the TidyTuesday copy | Not recorded | [not verified] |

## File facts

All values in this table are [verified: planner, direct read 2026-11-16].

| Item | Value |
|---|---|
| Location in the clone | `data/hotels.csv` (ignored by git) |
| Size | 16,855,599 bytes |
| SHA-256 | 7c2ae42a7353905ea136e5c2287f17c92c5435826598bfbb8491c6f0c7b1fc06 |
| Encoding | UTF-8 without BOM |
| Line endings | LF |
| Rows (excluding header) | 119,390 |
| Columns | 32 |
| Header | Matches the column list in DATA-QUALITY.md exactly |
| Profile figures | V-01 to V-06 in DATA-QUALITY.md all reproduce |
| Ignored by git | Yes. `git check-ignore` reports `.gitignore` line 10 (`*.csv`) |

To check a copy, compare its hash with the SHA-256 above, for example with `Get-FileHash -Algorithm SHA256` on the file in `data/`.

## Power BI Desktop

| Item | Value | Label |
|---|---|---|
| Install type | .exe | [verified: owner, 2026-11-16] |
| Version | October 2026, build 2.159.1231.0 (26.10) x64 | [verified: owner's Desktop feedback report 2026-11-16] |
| Preview option "Detect and reload external PBIP changes" | Not seen in the report's preview lists. Owner to check in Options > Preview features (A0.4). | [not verified] |

Only the version is taken from the feedback report. No other field from it is recorded.
