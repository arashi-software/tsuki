import terminal

proc displayInfo*(x: string) =
  stdout.styledWriteLine(fgCyan, "Info: ", fgDefault, x)

proc displaySuccess*(x: string) =
  stdout.styledWriteLine(fgGreen, "Success: ", fgDefault, x)

proc displayWarning*(x: string) =
  stdout.styledWriteLine(fgYellow, "Warning: ", fgDefault, x)

proc displayError*(x: string, quitProcess = false) =
  stdout.styledWriteLine(fgRed, "Error: ", fgDefault, x)
  if quitProcess:
    quit 1
