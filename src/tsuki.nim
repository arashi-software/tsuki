import tsuki/[args, config, cli, share]
import std/[os, osproc, strutils, algorithm]
import moustachu

let tsukiConfigDir* = getConfigDir() / "tsuki"
const exampleConfig* = staticRead("../examples/config.kdl")

# Parse CLI args
spec.parseOrHelp("Tsuki - ムーン")

if spec.init.seen:
  if not dirExists(tsukiConfigDir / "apps"):
    displayInfo("Creating tsuki config and apps directory")
    createDir(tsukiConfigDir / "apps")
    displaySuccess("Created tsuki config and apps directory")
  else:
    displayWarning("Tsuki config and apps directories already exist... Skipping")
  if not fileExists(tsukiConfigDir / "config.kdl"):
    displayInfo("Creating initial tsuki config")
    writeFile(tsukiConfigDir / "config.kdl", exampleConfig)
    displaySuccess("Created initial tsuki config")
  else:
    displayWarning("Tsuki config file already exists... Skipping")
  quit 0

let doc = parseKdl(readFile(tsukiConfigDir / "config.kdl"))

let themes = doc.decodeKdl(TsukiThemes, "themes")
let commands = doc.decodeKdl(TsukiCommands, "commands")
let apps = doc.decodeKdl(TsukiApps, "apps")
var theme = spec.theme.value

if spec.list.seen or spec.rofi.seen:
  var themeNames: seq[string] = @[]
  for thm in themes.keys:
    themeNames.add(thm)
  themeNames.sort()
  if spec.rofi.seen:
    if not "rofi".inPath():
      displayError("Could not find rofi binary in path... Quitting", true)
    var cmd = execCmdEx("echo '$#' | rofi -dmenu -i -p 'Theme'" % [themeNames.join("\n")])
    theme = cmd.output.strip()
  elif spec.list.seen:
    echo themeNames.join("\n")
    quit 0

if spec.backup.seen:
  let outdir =
    if backup.output.value == "":
      getHomeDir() / ".backup"
    else:
      backup.output.value
  createDir(outdir)
  for k, v in apps.pairs:
    let dir = v.target.replace("~", getHomeDir()).replace("//", "/")
    if dirExists(dir):
      displayInfo("Backing up directory '" & dir & "' to '" & outdir & "'")
      copyDirWithPermissions(dir, outdir / splitPath(dir).tail)
      displaySuccess("Backed up directory '" & dir & "' to '" & outdir & "'")
  quit 0

for k, v in apps.pairs:
  let dir = v.target.replace("~", getHomeDir()).replace("//", "/")
  if not dirExists(tsukiConfigDir / "apps" / k):
    displayError("No config directory exists for app '" & k & "'", true)
  for file in v.templates:
    if not fileExists(tsukiConfigDir / "apps" / k / file):
      displayError("File '" & file & "' doesn't exist in app '" & k & "'", true)
  if not dirExists(dir):
    displayWarning("Target directory '" & dir & "' doesn't exist")
    displayInfo("Creating directory '" & dir & "'")
    createDir(dir)
    displayInfo("Created directory '" & dir & "'")

if spec.check.seen:
  displaySuccess("No errors detected")
  quit 0

if theme == "":
  displayError("You must specify a valid theme name", true)
if not themes.hasKey(theme):
  displayError("Theme '" & theme & "' isn't defined in your config", true)

for k, v in apps.pairs:
  let dir = v.target.replace("~", getHomeDir()).replace("//", "/")
  for file in v.templates:
    let buf = readFile(tsukiConfigDir / "apps" / k / file)
    var c = newContext()
    for k, v in themes[theme]:
      c[k] = v
    writeFile(dir / file, render(buf, c))
  displaySuccess("Changed configuration for app '$#'" % [k])

for command in commands:
  displayInfo("Executing command '$#'" % [command])
  discard execShellCmd(command)
  displaySuccess("Finished executing '$#'" % [command])
