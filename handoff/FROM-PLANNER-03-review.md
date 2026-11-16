# FROM-PLANNER-03: device check and source details

Planner's note, recorded verbatim by CC on 2026-11-16. This is the revised version. It replaced an earlier draft before the commit was pushed.

---

FROM-PLANNER-03 (apply, commit locally, do NOT push; show me the diff first)

Verified on the owner's device 2026-11-16 (planner, direct read of the file): data/hotels.csv, 16,855,599 bytes, SHA-256 7c2ae42a7353905ea136e5c2287f17c92c5435826598bfbb8491c6f0c7b1fc06, UTF-8 without BOM, LF line endings, 119,390 rows, 32 columns. Header matches the column list in DATA-QUALITY.md exactly. All figures in V-01..V-06 reproduce. git check-ignore confirms .gitignore line 10 (*.csv) ignores it.

1. Create docs/DATA-SOURCE.md (P0-04 template filled):
   - Provenance: TidyTuesday merged copy. Original article: Antonio, de Almeida, Nunes 2019, Data in Brief 22:41-49, doi 10.1016/j.dib.2018.11.126.
   - Licence wording exactly as in R01: article CC BY 4.0; data files supplied with the article; their licence inferred from the article [inferred].
   - Size, SHA-256, rows and columns as above, labelled [verified: planner, direct read 2026-11-16].
   - Desktop: install type .exe; version October 2026, build 2.159.1231.0 (26.10) x64 [verified: owner's Desktop feedback report 2026-11-16]. Record no other field from that report.
   - Preview option "Detect and reload external PBIP changes": not seen in the report's preview lists; status [not verified], owner to check in Options > Preview features.
   - No local path anywhere.
2. DQ-03 / A1.3: the 488 rows without a country hold the text "NULL", not an empty string [verified: planner, direct read 2026-11-16]. Update the DQ-03 wording and its "Uncertain" line. Keep the rule that handles both.
3. adr definition [verified: planner, source paper]: sum of all lodging transactions divided by total nights stayed. Replace "[not verified]" for the adr definition in MEASURES.md (Revenue convention line) and in R15 (move it to the verified list).
4. P0-05 wording: do not write "its licence (CC BY 4.0)" for the file. Use the R01 wording (article CC BY 4.0, file licence inferred).
5. Data folder: the file lives in data/ (not data/raw/). Replace "data/raw/" with "data/" in all docs and in P0-05, A0.8 and R03. Keep data/lookup/ tracked.
6. Check: no local path, email, user ID, session ID or personal name in any new or changed text (grep before commit). Keep UTF-8 without BOM.
7. Regenerate handoff/PLAN-BUNDLE.md. Add handoff/FROM-PLANNER-03-review.md with this text. Update handoff/README.md index.
8. Report: diff stat, scan result, git status (the CSV must not appear). Wait for my approval before any push.
