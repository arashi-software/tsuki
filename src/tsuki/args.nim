import therapist, parsecfg, streams
export therapist

const version* = staticRead("../../tsuki.nimble").newStringStream.loadConfig
  .getSectionValue("", "version")

const danger = defined(danger)
const release = defined(release)

var build =
  if danger:
    "unsafe"
  elif release:
    "release"
  else:
    "debug"

let subcommand* = (help: newHelpArg())
let backup* = (
  help: newHelpArg(),
  output: newStringArg(
    @["-o", "--output"], help = "Where to putput the backup", optional = true
  ),
)

let spec* = (
  theme: newStringArg(@["<theme>"], help = "The theme to enable", optional = true),
  version: newMessageArg(
    @["-v", "--version"], version & " [" & build & "]", help = "Prints version"
  ),
  init: newCommandArg(
    @["init", "setup"],
    subcommand,
    help = "Setup your tsuki config directory. Run this first",
  ),
  check: newCommandArg(
    @["check", "validate"], subcommand, help = "Check your tsuki setup for any errors"
  ),
  list: newCommandArg(
    @["list"], subcommand, help = "List your configured themes"
  ), 
  rofi: newCommandArg(
    @["rofi"], subcommand, help = "Open tsuki rofi frontend"
  ),
  backup: newCommandArg(@["backup"], backup, help = "Back up your current config files"),
  help: newHelpArg(),
  helpCmd: newHelpCommandArg("help", help = "Show help message"),
)
