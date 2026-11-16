# FROM-PLANNER-04: README, check script, preview option, Phase 1 M drafts

Planner's note, recorded verbatim by CC on 2026-11-16.

---

FROM-PLANNER-04 (apply, commit locally, do NOT push; show me the diff first)

Context: the planner wrote README.md and scripts/check-no-local-paths.ps1 directly into the working tree (P0-01, P0-03). They are uncommitted. The planner could not run PowerShell, so the script is untested. The owner confirmed on 2026-11-16 that the Desktop preview option "Detect and reload external PBIP changes" exists and is enabled [verified: owner].

1. Run scripts/check-no-local-paths.ps1 from the repo. Report PASS/FAIL and fix any bug in the script itself (a regex or syntax error). If it reports findings in tracked files, list them as file:line only and stop.
2. Review README.md against the honesty rules: nothing claimed that is not built, CV wording "project covering PL-300 skill areas", data stated as historical. Fix anything off. Keep UTF-8 without BOM.
3. DATA-SOURCE.md: change the preview-option row to "exists and is enabled [verified: owner, 2026-11-16]". PLAN.md A0.4 and R05: record the same. Keep the rule "CC edits TMDL only while Desktop is closed" until it is tested in Phase 1.
4. Do NOT record a decision for R04. The owner has not confirmed it. Leave it pending, with the placeholder plus check script as the proposed default.
5. Mark P0-01, P0-03 and P0-04 as done in PLAN.md (a short status line per task, with the date). Do not mark P0-05 to P0-09.
6. Draft the Phase 1 Power Query M as text files in src/m/ (extension .pq), each labelled [not tested]:
   - parameter DataFolderPath (placeholder value, no real path) and the source query for data/hotels.csv, with Csv.Document options and culture "en-US";
   - stg_Bookings with DQ-01 to DQ-09 and DQ-13/DQ-16 as written in DATA-QUALITY.md. Column names must be taken from the actual header listed in DATA-QUALITY.md. country uses the text "NULL" (DQ-03);
   - one row-count check per step (expected 119,390) so the owner can compare against the ledger.
   Do not write the fact, dimension, Date or aggregation queries yet. Read the M function pages still marked "not read" in LEARN-SOURCES (Table.PromoteHeaders, Table.AddIndexColumn) before using them, and add them to LEARN-SOURCES with the date.
7. Run the check script again on the final tree. Regenerate handoff/PLAN-BUNDLE.md. Add handoff/FROM-PLANNER-04-review.md with this text and update handoff/README.md.
8. Commit locally. Report: diff stat, script result, git status (no CSV), and the list of owner steps needed in Desktop to apply src/m/. Wait for my approval before any push.
