import kdl/decoder, kdl, tables
export decoder, kdl, tables

type
  TsukiThemes* = Table[string, Table[string, string]]
  TsukiCommands* = seq[string]
  TsukiApps* = Table[string, TsukiApp]
  TsukiApp* = object
    target*: string
    templates*: seq[string]
