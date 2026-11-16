# Learn sources

Status: planning document. Nothing here has been tested in Power BI Desktop.

## How these sources were read

- No Microsoft Learn MCP server was available in this session. Pages were read on 2026-11-16 with an automated web fetch. The fetch returned page text and metadata, and CC worked from that text.
- "Page date" is the page's own metadata (`updated_at`, with `ms.date` where it differs a lot). None of the pages showed a visible "last updated" line in the fetched text.
- All dates read: 2026-11-16.
- Short phrases are paraphrased. Exact wording is on the pages themselves.
- Labels used in the other docs: `[verified: Sxx]` means the claim matches source Sxx below. `[inferred]` means CC reasoned it from one or more sources but no page states it. `[not verified]` means no source was checked.

## Source IDs

### Exam

| ID | Page | URL | Page date |
|---|---|---|---|
| S01 | Study guide for Exam PL-300 | https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/pl-300 | updated 2026-11-05 (ms.date 2026-03-07) |

- What it says: skills measured as of 20 April 2026. Four areas: Prepare the data 25-30%, Model the data 25-30%, Visualize and analyze the data 25-30%, Manage and secure Power BI 15-20%. It lists 78 objective bullets (17 / 16 / 30 / 15). The change log marks three sub-areas as "Minor" changes and does not say what changed. It does not say the exam is retiring. It points to a new practice assessment.
- What the plan depends on: the coverage table in PLAN.md (one row per bullet).
- Still unverified: what the "Minor" changes were. Whether the guide changes again before the owner sits the exam. Re-check before Phase 5.

### Power BI Desktop projects (PBIP) and TMDL

| ID | Page | URL | Page date |
|---|---|---|---|
| S02 | Power BI Desktop projects overview | https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-overview | 2026-09-29 |
| S03 | Project semantic model folder | https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-dataset | 2026-09-29 |
| S04 | Project report folder | https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-report | 2026-09-29 |
| S05 | Edit PBIP files outside Desktop | https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-external-editing | 2026-09-29 |
| S06 | TMDL view in Desktop | https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-tmdl-view | 2026-09-29 |
| S07 | TMDL overview (language) | https://learn.microsoft.com/en-us/analysis-services/tmdl/tmdl-overview | 2026-06-11 |

- What they say:
  - PBIP and the PBIR report format are generally available. PBIR is the default report format (S04, S05).
  - A project has a `.pbip` file, a `.SemanticModel` folder and a `.Report` folder (S02).
  - The semantic model folder holds a `definition` folder when the model is saved as TMDL. `definition.pbism` version 4.0 or above allows TMDL (S03).
  - `.pbi/cache.abf` is a local copy of the model and data. `.pbi/localSettings.json` holds local settings. Desktop writes a `.gitignore` that excludes both, but only if no `.gitignore` exists yet in the folder or parent repo (S02, S03).
  - A project can open without `cache.abf`, and then it opens without data (S03).
  - Editing project files outside Desktop is supported, and the pages name VS Code and Notepad. Write operations may cause unexpected behaviour (S02).
  - Invalid TMDL makes Desktop show an error with the location to fix (S03). It can stop the project opening (S02).
  - Automatic reload of external changes is a preview feature. It needs the August 2026 Desktop release or later and the preview switch "Detect and reload external PBIP changes" (S05). S06 says Desktop must be restarted to load external TMDL edits. The pages contradict each other here; the restart is probably the non-preview behaviour [inferred].
  - Some report files must not be edited outside Desktop: report.json, mobileState.json, semanticModelDiagramLayout.json, diagramLayout.json, and definition.pbir during the preview (S02, S05).
  - Sensitivity labels are not supported with PBIP (S02).
  - Edited files must be saved as UTF-8 without BOM. Desktop uses CRLF line endings (S02).
  - TMDL syntax: tables, columns, measures with a format string, M partitions and relationships, with the indentation rules (S07).
  - TMDL view in Desktop is generally available (S06).
- What the plan depends on: CC can write TMDL, M and DAX as text, and the owner opens it in Desktop. The `.gitignore` rules. Desktop can open the project after a clone (no cache).
- Still unverified:
  - No page says in one sentence that a whole model can be written from scratch as TMDL and then opened in Desktop. The plan therefore has the owner create the project skeleton in Desktop first, and CC only edits the definition files after that.
  - Whether TMDL is the default storage format in the owner's Desktop build.
  - The restart vs reload conflict.

### Power Query M

| ID | Page | URL | Page date |
|---|---|---|---|
| S08 | Csv.Document | https://learn.microsoft.com/en-us/powerquery-m/csv-document | 2026-08-15 |
| S09 | Table.ReplaceValue | https://learn.microsoft.com/en-us/powerquery-m/table-replacevalue | 2026-04-01 |
| S10 | Table.TransformColumnTypes | https://learn.microsoft.com/en-us/powerquery-m/table-transformcolumntypes | 2026-04-30 |
| S11 | Table.ReplaceErrorValues | https://learn.microsoft.com/en-us/powerquery-m/table-replaceerrorvalues | 2026-03-31 |
| S12 | Table.SelectRows | https://learn.microsoft.com/en-us/powerquery-m/table-selectrows | 2026-03-31 |
| S13 | Table.AddColumn | https://learn.microsoft.com/en-us/powerquery-m/table-addcolumn | 2026-03-31 |
| S14 | Date.AddDays | https://learn.microsoft.com/en-us/powerquery-m/date-adddays | 2026-06-18 |
| S15 | Data types in Power Query | https://learn.microsoft.com/en-us/power-query/data-types | 2026-08-14 |
| S16 | Data profiling tools | https://learn.microsoft.com/en-us/power-query/data-profiling-tools | 2025-08-28 |
| S17 | Query parameters | https://learn.microsoft.com/en-us/power-query/power-query-query-parameters | 2026-04-09 |

- What they say:
  - Csv.Document options: Delimiter, Columns, Encoding (default 65001), QuoteStyle (S08).
  - `Replacer.ReplaceValue` replaces whole values only. `Replacer.ReplaceText` replaces substrings (S09).
  - Table.TransformColumnTypes takes an optional culture such as "en-US" (S10).
  - The locale is used to read text as numbers or dates. Desktop uses the OS regional format by default. A wrong locale produces error values (S15).
  - Table.ReplaceErrorValues takes a list of {column, value} pairs. One example on the page does not match the stated syntax (S11).
  - Column profiling uses the first 1,000 rows by default. It can be switched to the entire data set from the status bar (S16).
  - Parameters can be used as step arguments. Manage Parameters is on the Home tab (S17).
- What the plan depends on: the cleaning rules in DATA-QUALITY.md. The culture choice. Profiling on the entire data set.
- Still unverified:
  - How a "NULL" text value behaves in a type conversion. It is implied to give an error, but not stated for this function.
  - Whether a parameter can hold the file path in the source step. No page gives an example.
  - These functions were not fetched: Table.PromoteHeaders, Table.AddIndexColumn, Table.NestedJoin, Table.Group, Table.Unpivot, Table.Pivot, Table.Transpose, Json.Document, List.Dates, Date.FromText. Check each page before Phase 1.

### Modelling and date tables

| ID | Page | URL | Page date |
|---|---|---|---|
| S18 | Date table guidance | https://learn.microsoft.com/en-us/power-bi/guidance/model-date-tables | 2026-01-02 |
| S19 | Set and use date tables in Desktop | https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-date-tables | 2026-10-07 |
| S20 | Auto date/time | https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-auto-date-time | 2026-05-21 |
| S21 | Star schema guidance | https://learn.microsoft.com/en-us/power-bi/guidance/star-schema | 2026-04-01 |
| S22 | Active vs inactive relationships | https://learn.microsoft.com/en-us/power-bi/guidance/relationships-active-inactive | 2026-01-02 |
| S23 | USERELATIONSHIP | https://learn.microsoft.com/en-us/dax/userelationship-function-dax | 2026-01-13 |
| S24 | Create and manage relationships | https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-create-and-manage-relationships | 2026-05-21 |

- What they say:
  - Date table needs: a date column, unique values, no blanks, no missing dates, full years (S18).
  - Desktop checks unique, non-null and contiguous values when marking a date table (S19).
  - Marking is required for classic time intelligence. Marking removes the auto date/time tables for the model (S18, S19).
  - A date table can be built with Power Query or DAX. A DAX clone copies columns only, not formats or hierarchies (S18).
  - Auto date/time is set per file or globally. It is on by default for new installs (S20).
  - Role-playing dimensions: one date table with inactive relationships plus USERELATIONSHIP, or one table per role. Use one table per role when two roles must filter at the same time (S21, S22).
  - RLS filters only flow through active relationships (S22).
  - USERELATIONSHIP cannot be used when RLS is defined on the table that holds the measure. Its example is RLS on DimCustomer (S23).
  - Cardinality options. "Both" is suited to a single star but should be avoided when fact tables share dimensions (S24).
  - Degenerate dimensions and junk dimensions (S21).
- What the plan depends on: DATA-MODEL.md (role-playing design, date table, relationship directions).
- Still unverified: whether USERELATIONSHIP fails in this model when RLS is on the Hotel table and the measures live in a separate measure table. This must be tested in Phase 4.

### DAX: CALCULATE and time intelligence

| ID | Page | URL | Page date |
|---|---|---|---|
| S25 | CALCULATE | https://learn.microsoft.com/en-us/dax/calculate-function-dax | 2026-08-04 |
| S26 | Time intelligence functions | https://learn.microsoft.com/en-us/dax/time-intelligence-functions-dax | 2026-01-22 |
| S27 | SAMEPERIODLASTYEAR | https://learn.microsoft.com/en-us/dax/sameperiodlastyear-function-dax | 2026-01-22 |
| S28 | TOTALYTD | https://learn.microsoft.com/en-us/dax/totalytd-function-dax | 2026-01-22 |
| S29 | DATESYTD | https://learn.microsoft.com/en-us/dax/datesytd-function-dax | 2026-01-22 |
| S30 | DIVIDE | https://learn.microsoft.com/en-us/dax/divide-function-dax | 2026-01-22 |
| S31 | DIVIDE vs divide operator (guidance) | https://learn.microsoft.com/en-us/dax/best-practices/dax-divide-function-operator | 2026-01-13 |
| S32 | Time intelligence in Desktop (classic and calendar-based) | https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-time-intelligence | 2026-10-07 |

- What they say:
  - CALCULATE takes boolean filters, table filters and modifiers (REMOVEFILTERS, ALL, KEEPFILTERS, USERELATIONSHIP, CROSSFILTER). A boolean filter can reference columns from one table only. It cannot reference measures or use a nested CALCULATE (S25).
  - Time intelligence needs a marked date table (S26). Classic time intelligence throws an error when dates are missing (S32).
  - Calendar-based time intelligence is in preview. It is turned on with the "Enhanced DAX Time Intelligence" preview switch, and the page recommends it (S32).
  - SAMEPERIODLASTYEAR, TOTALYTD and DATESYTD syntax. The year-end parameter is a string such as "6/30" (S27-S29).
  - DIVIDE returns BLANK when the denominator is 0 or BLANK and no alternate result is given (S30, S31). The guidance says to prefer BLANK so visuals hide empty groups (S31).
- What the plan depends on: MEASURES.md. The choice of classic (GA) time intelligence over calendar-based (preview).
- Still unverified: how calendar-based time intelligence behaves in the owner's Desktop build. The plan does not depend on it.

### Security, privacy, licensing and the Service

| ID | Page | URL | Page date |
|---|---|---|---|
| S33 | Row-level security (Fabric / Power BI) | https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security | 2026-07-08 |
| S34 | RLS guidance | https://learn.microsoft.com/en-us/power-bi/guidance/rls-guidance | 2026-01-02 |
| S35 | Object-level security | https://learn.microsoft.com/en-us/fabric/security/service-admin-object-level-security | 2026-07-01 |
| S36 | Privacy levels (Power Query) | https://learn.microsoft.com/en-us/power-query/privacy-levels (requested via the power-bi/enterprise/desktop-privacy-levels URL) | 2026-08-20 |
| S37 | Data privacy firewall | https://learn.microsoft.com/en-us/power-query/data-privacy-firewall | 2026-08-12 |
| S38 | Data sources in Desktop | https://learn.microsoft.com/en-us/power-bi/connect-data/desktop-data-sources | 2026-10-07 |
| S39 | Features by licence type | https://learn.microsoft.com/en-us/power-bi/fundamentals/service-features-license-type | 2026-08-31 |
| S40 | Fabric licences | https://learn.microsoft.com/en-us/fabric/enterprise/licenses | 2026-11-10 |
| S41 | Self-service sign-up | https://learn.microsoft.com/en-us/power-bi/fundamentals/service-self-service-signup-for-power-bi | 2026-03-24 |
| S42 | Publish to web | https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-publish-to-web | 2026-04-01 |
| S43 | Get Power BI Desktop | https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-get-the-desktop | 2026-10-13 |
| S44 | Sensitivity labels overview | https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-sensitivity-label-overview | 2026-09-29 |
| S45 | Enable sensitivity labels | https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-enable-data-sensitivity-labels | 2026-02-17 |
| S46 | Power BI features available to free users (re-read 2026-11-16 for Free + My workspace) | https://learn.microsoft.com/en-us/power-bi/fundamentals/end-user-features | 2026-09-24 |
| S47 | Copilot in Power BI | https://learn.microsoft.com/en-us/power-bi/create-reports/copilot-introduction | 2026-08-31 |
| S48 | On-premises data gateway | https://learn.microsoft.com/en-us/power-bi/connect-data/service-gateway-onprem | 2026-09-24 |
| S49 | Scheduled refresh | https://learn.microsoft.com/en-us/power-bi/connect-data/refresh-scheduled-refresh | 2026-05-06 |
| S54 | Licenses and subscriptions for business users (added 2026-11-16) | https://learn.microsoft.com/en-us/power-bi/consumer/end-user-license | 2026-07-23 (ms.date 2025-11-25) |

- What they say:
  - RLS in Desktop: Modeling > Manage roles, with a default editor and a DAX editor. Dynamic rules need the DAX editor (S33). Test with View as (S34).
  - Members are assigned in the Service on the semantic model Security page (S33).
  - RLS applies only to the workspace Viewer role, not to Admin, Member or Contributor (S33).
  - USERNAME() returns DOMAIN\user in Desktop. In the Service, both USERNAME() and USERPRINCIPALNAME() return the UPN (S33).
  - The RLS page notes that USERELATIONSHIP with RLS may cause errors (S33).
  - OLS can be defined in TMDL view with a script (S35).
  - Privacy levels are None, Private, Organizational and Public. Set them in Data source settings > Edit permissions. Ignoring privacy levels is off by default and risky (S36).
  - Formula.Firewall is triggered when one query both accesses a source and references other queries, or combines sources with incompatible privacy levels. The documented fix is restructuring the queries (S37).
  - Desktop is a free download (S43).
  - A free licence cannot share or publish to other people's workspaces. Creating items outside My workspace needs Pro or PPU (S39, S40, S46). Free users cannot create apps (S46).
  - Power BI Service sign-up needs a work or school account. Consumer email domains cannot be used directly. A Microsoft 365 trial creates a work account but needs a credit card (S41).
  - The Fabric trial is 60 days (S40).
  - Publish to web makes the report public on the internet and needs an admin tenant setting (S42).
  - Sensitivity labels need a Microsoft Purview / AIP P1 or P2 licence plus Pro or PPU, and a tenant setting (S44, S45).
  - Copilot needs paid F2+ or P1+ capacity. Pro or PPU alone is not enough. Trial capacity is not supported (S47).
  - A gateway is needed when the Service cannot reach the data over the internet (S48).
  - Scheduled refresh allows up to 8 a day on Pro and 48 on PPU or Premium. A schedule is deactivated after 4 consecutive failures (S49).
- What the plan depends on:
  - The split of PL-300 objectives into Desktop-coverable vs Service-dependent vs not coverable.
  - The RLS design.
  - Setting the privacy level on the CSV source.
- Still unverified:
  - Licence needed to assign RLS members (no page read covers it).
  - Pro and PPU trial length.
  - Licence details for data alerts as a separate feature, deployment pipelines and gateway.
  - Whether a CSV in OneDrive or SharePoint avoids the gateway.
  - The URL https://learn.microsoft.com/en-us/power-query/privacy-firewall returned HTTP 404. S37 was used instead.

#### Free licence in My workspace (S46 re-read, S54 added, 2026-11-16)

The planner asked for "Power BI features available to free users" and "Licenses and subscriptions for business users" as new S-IDs (FROM-PLANNER-02). The first is the same page as S46, so S46 was updated instead of adding a duplicate ID. The second is S54. CC re-read both pages on 2026-11-16.

- **Allowed in My workspace for a free user:**
  - create and edit reports for personal use,
  - create dashboards and pin tiles,
  - add alerts to tiles,
  - schedule refresh (S46).
  - Create content in My workspace: yes (S54).
- **Not allowed for a free user:**
  - create, edit or delete a workspace,
  - create or reshare an app,
  - add endorsements,
  - share content, a semantic model, or manage permissions,
  - publish to app workspaces (S46, S54).
  - Workspace roles other than Viewer need Pro or PPU (S46).
- **Subscriptions:** listed only on qualifying capacity, with the Viewer role, when an administrator enables them. Subscribing on shared capacity in My workspace is not documented as allowed (S46).
- **Admin settings:** an administrator or tenant setting can disable some otherwise available features (S46).
- **Still unverified:**
  - Neither page mentions publishing from Desktop to My workspace in so many words. P0-09 tests it.
  - Item-level access is not covered as its own topic.
  - S54's canonical URL is /power-bi/fundamentals/end-user-license; the fetch did not redirect.

### Report features, performance and other modelling features

| ID | Page | URL | Page date |
|---|---|---|---|
| S50 | Calculation groups | https://learn.microsoft.com/en-us/power-bi/transform-model/calculation-groups | 2026-05-21 |
| S51 | Visual calculations | https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-visual-calculations-overview | 2026-10-14 |
| S52 | Performance Analyzer | https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-performance-analyzer | 2026-07-23 |
| S53 | DAX query view | https://learn.microsoft.com/en-us/power-bi/transform-model/dax-query-view | 2026-10-23 |

- What they say:
  - Calculation groups can be created in Model view or TMDL view. Desktop asks to turn on "discourage implicit measures". Measures become a variant type while a calculation group exists (S50).
  - Visual calculations are created in the visual's edit mode. They support RUNNINGSUM, MOVINGAVERAGE and LOOKUP. They cannot use USERELATIONSHIP or RELATED. They cannot be pinned to dashboards or used with publish to web (S51).
  - Performance Analyzer is on the Optimize ribbon. It can copy a visual's query, run it in DAX query view, and export a JSON log (S52).
  - DAX query view has quick queries such as "Define all measures" and "Show column statistics". DEFINE MEASURE blocks can be written to the model with "Update model with changes" (S53).
- What the plan depends on:
  - Objectives 2.2.8, 3.1.11 and 2.3.2.
  - The route by which CC's DAX text gets into the model: a DAX query view script that the owner runs and applies.
- Still unverified: GA or preview status of calculation groups in Desktop, visual calculations and DAX query view. The pages do not say.

## Sources not read (gaps to close before the related phase)

| Topic | Needed for | Status |
|---|---|---|
| Automatic page refresh | Objective 3.2.13 | [not verified]. CC believes it needs DirectQuery or a change-detection source, so it would not apply to an Import CSV model. Read the Learn page before marking it "not covered". |
| Personalize visuals | 3.2.11 | not read |
| Mobile layout, accessibility, bookmarks, drillthrough, tooltips, sync slicers, export settings | Phase 3 | not read |
| Analyze feature, Key influencers, decomposition tree, anomaly detection, forecasting, clustering | 3.3.x | not read |
| Quick measures | 2.2.6 | not read |
| Map visual tenant or online requirements | Markets page | not read |
| Workspaces, apps, endorsement, subscriptions, data alerts, dashboards | 4.1.x | not read |
| Paginated reports (when to use) | 3.1.10 | not read |
| Direct Lake / DirectQuery / Import comparison | 1.1.3 | not read |

## Dataset source (not a Learn page)

Label `[verified: planner, source paper]` means verified by the planner from the following source: Antonio, de Almeida, Nunes (2019), Data in Brief 22:41-49, doi 10.1016/j.dib.2018.11.126. The planner read the PDF at the ISCTE repository (hdl 10071/16929) on 2026-11-16 through a summarising fetch. The owner is to confirm the exact wording. CC has not read this source.

- Citation: Antonio, N., de Almeida, A., Nunes, L. (2019). "Hotel booking demand datasets". Data in Brief 22:41-49. doi 10.1016/j.dib.2018.11.126 [verified: planner, source paper].
- Article licence: CC BY 4.0 [verified: planner, source paper]. The data are supplied with the paper [verified: planner, source paper]. The licence of the data files is the same as the article's [inferred]. See R01.
- Content (all [verified: planner, source paper]):
  - Two datasets: H1 Resort Hotel 40,060 rows and H2 City Hotel 79,330 rows, 31 variables each.
  - Arrivals from 1 July 2015 to 31 August 2017.
  - Agent and Company "NULL" means "not applicable", not missing.
  - Meal "Undefined" and "SC" both mean no meal package.
  - lead_time is the number of days between entering the booking in the PMS and arrival.
  - reservation_status_date is the date the last status was set.
- The owner's file is the merged TidyTuesday copy, not the original files (R14).
