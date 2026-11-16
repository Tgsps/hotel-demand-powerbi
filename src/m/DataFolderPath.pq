// DataFolderPath  [not tested]
// Task P1-01. Power Query parameter, type Text, required.
//
// Value: the folder that contains hotels.csv, ENDING WITH A BACKSLASH.
// The value below is a placeholder, not a path. Set the real value only in
// Power BI Desktop. Never commit it (R04, decision pending).
//
// Preferred way to create it: Home > Manage parameters > New parameter,
// Name = DataFolderPath, Type = Text, Required = on (S17).
// The M text below is what such a parameter query looks like in the
// Advanced Editor [not verified: the meta record form is not on the pages read].

"SET-IN-DESKTOP" meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]
