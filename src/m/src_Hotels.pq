// src_Hotels  [not tested]
// Task P1-01 / P1-02. Reads data/hotels.csv and promotes the header row.
// Load: disabled (staging query, P1-12).
//
// Functions (docs/LEARN-SOURCES.md):
//   File.Contents (S62), Csv.Document (S08), Table.PromoteHeaders (S55).
// Expected result: 119,390 rows, 32 columns, all values still text.
// Types are set in stg_Bookings_Steps with culture "en-US" (S10, S15).

let
    // Raw file: header row + 119,390 data rows = 119,391 rows [inferred].
    Source = Csv.Document(
        File.Contents(DataFolderPath & "hotels.csv"),
        [Delimiter = ",", Columns = 32, Encoding = 65001, QuoteStyle = QuoteStyle.Csv]
    ),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars = true, Culture = "en-US"])
in
    Promoted
