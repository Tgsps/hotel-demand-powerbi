# Handoff folder

The planner and Claude Code (CC) exchange files here. Nothing in this folder is part of the Power BI project itself.

## Naming

- `TO-CC-NN-<topic>.md`: a brief or answer from the planner to CC.
- `FROM-CC-NN-<topic>.md`: a report from CC to the planner.
- `NN` is a two-digit sequence number shared by both directions. A reply keeps the number of the message it answers.

## Rules

- English, no emoji.
- No emails, tokens, secrets, personal data or local file paths.
- Every factual claim is labelled `[verified: source]`, `[inferred]` or `[not verified]`. The source IDs are in docs/LEARN-SOURCES.md.
- Each FROM-CC report says what was done, what could not be verified, and which decisions are needed.
- Files are never edited after they are committed. A correction goes in a new numbered file.

## Index

| File | Direction | Topic |
|---|---|---|
| FROM-CC-01-plan.md | CC to planner | Planning deliverables, open items, decisions needed |
