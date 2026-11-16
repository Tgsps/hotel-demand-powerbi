# FROM-PLANNER-02: review of main 9bffc37

Planner's note, recorded verbatim by CC on 2026-11-16.

---

Verified: content scan 0 (incl. PLAN-BUNDLE.md); no data files tracked; bundle matches docs verbatim; V-06 sum, 37.04%, V-02 split and coverage counts re-derived and correct.

1. Order: do P0-02 (.gitignore) first and push it (with owner approval) before the owner places any data file inside the clone. Update PLAN.md Phase 0 order.

2. Original source [verified: Antonio, de Almeida, Nunes 2019, Data in Brief 22:41-49, doi 10.1016/j.dib.2018.11.126; PDF at ISCTE repository hdl 10071/16929; read 2026-11-16 via a summarising fetch, owner to confirm exact wording]:
   - Article licence: CC BY 4.0. Data "supplied with the paper". Licence of the data files: [inferred: same as article]. README wording: "Article published under CC BY 4.0; the data files are supplied with the article; their licence is inferred from the article licence."
   - Two datasets: H1 Resort 40,060 rows, H2 City 79,330 rows, 31 variables each; arrivals 1 Jul 2015 to 31 Aug 2017. Update R14: a real append of the two original files is possible if the owner obtains them. Recommendation pending owner decision.
   - Agent/Company "NULL" = "not applicable", not missing. DQ-01/DQ-02: keep null for typing, label the member "Not applicable".
   - Meal "Undefined/SC" = no meal package. DQ-10: resolved for meal.
   - lead_time = days from booking entry in the PMS to arrival (BookingDate meaning verified). reservation_status_date = date the last status was set (StatusDate as cancellation date for cancelled rows: [inferred]).

3. Free + My workspace [verified: Learn "Power BI features available to free users" and "Licenses and subscriptions for business users", 2026-11-16]. Add both as new S-IDs.
   - Move to Not covered (Free): 4.1.1, 4.1.2, 4.1.7, 4.2.1, 4.2.2, 4.2.3.
   - Keep Service-only [pending P0-09] and test only these: 4.1.3 publish to My workspace; 4.1.4 create dashboard and pin; 4.1.6 data alert on a tile (subscriptions need qualifying capacity, so at most Partial); 4.1.9 scheduled refresh (local CSV needs a gateway [inferred: S48]); 4.2.5 [not verified].
   - Note: tenant admin settings can disable some features; record any block.
   - Recount the coverage summary.

4. MEASURES.md: line 13, partial years now verified (V-06: 2015 Jul-Dec, 2017 Jan-Aug). Line 26 (M02): includes no-shows, DQ-15 confirmed.

5. DQ-08: record in Desktop whether the 180 zero-guest count treats the 4 "NA" children as 0.

Regenerate PLAN-BUNDLE.md after the edits. Push only with owner approval after scan.
