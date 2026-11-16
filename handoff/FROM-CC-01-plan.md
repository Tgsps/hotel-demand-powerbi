# FROM-CC-01: planning report

Date: 2026-11-16
Scope: planning only. No report built, no data files, nothing installed, no remote, no push.

## What I did

1. Created the folder `hotel-demand-powerbi` and a local git repo inside it (branch `main`, no remote).
2. Researched Microsoft Learn on 2026-11-16. No Microsoft Learn MCP server was available, so I read the pages with an automated web fetch. 53 pages were read and are listed in docs/LEARN-SOURCES.md, each with its URL, page date, what it says, what the plan depends on and what is still unverified. One URL (power-query/privacy-firewall) returned 404; I used power-query/data-privacy-firewall instead.
3. Wrote the deliverables:
   - docs/PLAN.md: six phases (0, 1, 2, 3, 4a/4b, 5), about 6.5-8 weeks at 6-8 hours a week. Each phase has acceptance checks written before its task list. Each task is marked CC or Owner. The coverage table has all 78 study-guide bullets.
   - docs/DATA-MODEL.md: a star schema with one fact table (one row per booking) and these dimensions:
     - Hotel, the RLS target.
     - 'Date' for arrival, active.
     - The same 'Date' for the status date, inactive and used with USERELATIONSHIP.
     - A separate 'Booking Date' table, active.
     - Seven small code dimensions.

     It also gives the reasoning and 12 rejected alternatives.
   - docs/MEASURES.md: 28 measures, 4 calculation-group items, 1 quick measure and 2 visual calculations. All are marked [not tested], with edge cases (cancellations, no-shows, adr = 0, the negative adr, the 5,400 outlier, zero-night stays, partial years).
   - docs/DATA-QUALITY.md: rules for the six known issues, ten candidate checks, the derived columns, and an empty row-count ledger for the owner to fill in.
   - docs/LEARN-SOURCES.md: the source list.
   - docs/RISKS-AND-OPEN-QUESTIONS.md: 24 risks, 8 ambiguities and 7 owner decisions.
4. Created this handoff folder and README.

## Coverage result

These counts come from the PLAN.md table [inferred: counted by CC]:

| Coverage | Bullets |
|---|---|
| Done in Desktop | 55 |
| Partial | 6 |
| Service only | 11 |
| Not covered | 6 |
| Total | 78 |

Why 6 bullets are not covered:
- Four are Copilot bullets. Copilot needs paid F2+ or P1+ capacity [verified: S47].
- One is sensitivity labels. They need Purview licensing and are not supported with PBIP [verified: S44, S45, S02].
- One is automatic page refresh. I believe it does not apply to an Import CSV model [not verified].

## What I could not verify

- **Dataset licence.** Not checked, and no licence is stated anywhere. The publisher's citation in LEARN-SOURCES is from my memory [not verified].
- **Writing a whole model as TMDL text.** No Learn page says a model can be written from scratch as TMDL and then opened in Desktop. The plan therefore has the owner create the PBIP skeleton first, and CC edits it afterwards.
- **Restart vs reload.** S05 and S06 conflict on whether a restart is needed after external edits. S05 says automatic reload is a preview feature in the August 2026 release or later.
- **Dataset field meanings.** These come from memory of the dataset paper: the adr definition, no-shows inside is_canceled, status date = cancel date, the meal codes, and whether two source files exist.
- **Candidate data issues DQ-07 to DQ-16.** None checked. I did not open the dataset.
- **Learn pages not yet read.** See the gaps table in LEARN-SOURCES. These cover automatic page refresh, personalization, the Phase 3 report features, workspaces, apps, dashboards, subscriptions, paginated reports, the storage-mode comparison, and the M function pages for PromoteHeaders, AddIndexColumn, NestedJoin, Group, Unpivot, Pivot, Transpose, Json.Document, List.Dates and Date.FromText.
- **Licensing gaps.** The licence needed to assign RLS members, the Pro and PPU trial lengths, and the licence rules for gateway and data alerts.
- **The planner's dataset figures.** I took them as given and labelled them [verified: planner brief]; I did not re-check them.

## Decisions needed (owner)

1. R01: verify the dataset licence at the publisher's page, and decide whether the repo can ever be public.
2. R02: Power BI Service access: none, a trial tenant (needs a card), or an existing work or school tenant.
3. R04: how to keep the local data folder path out of the committed PBIP files.
4. R11: confirm the weekly hours, or which phases to drop.
5. R12: the adr outlier threshold (after profiling).
6. R13: whether to add country names, and from which source.
7. R14: which original file(s) to download.

## Deviations from the brief

- The coverage table uses condensed paraphrases of the 78 objectives, one row per bullet in guide order. It does not reproduce the guide's text verbatim, to keep quotation from Learn short (ambiguity A02).
- No root README, `.gitignore` or scripts were created. They are Phase 0 tasks (P0-01 to P0-03). The repo holds only `docs/` and `handoff/`.

## Suggested next step

Planner reviews PLAN.md and the decisions list. Once R01, R02 and R04 are answered, CC can start Phase 0 (P0-01 to P0-04).
