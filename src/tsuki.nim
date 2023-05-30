import lib, 
       os, 
       jsony, 
       termui, 
       strutils, 
       json, 
       osproc

const exCfg = staticRead("../example/themes.tsk")

let
  confDir = getHomeDir() / ".tsuki"
  themes = listDirs(confDir / "themes")

if not fileExists(confDir / "themes.tsk"):
  if termuiConfirm("No themes.tsk file was found in the themes directory, shall I create one?"):
    writeFile(confDir / "themes.tsk", exCfg)
    echo "\nthemes.tsk file created!"
    quit 0
  else:
    quit 0

var cfgTxt = readFile(confDir / "themes.tsk")
if exCfg == cfgTxt:
  echo "Please go edit you themes file with valid information, as the example is filled with placeholder information and will not work."

var
  theme = paramStr(1)
  cfg = cfgTxt.fromJson(Themes)

if theme == "list":
  echo themes.join("\n")
  quit 0

if theme == "add":
  if paramCount() != 3:
    logError("Incorrect use of command. Correct use: 'tsuki add <srcFile | 'command'> <destFile | command>'")
    quit 1
  var
    srcFile = paramStr(2)
    destFile = paramStr(3)
  if srcFile == "command":
    cfg.commands.add(destFile)
  else:
    cfg.files.add(lib.File(
      src: srcFile,
      dest: destFile
    ))
  writeFile(confDir / "themes.tsk", pretty(%*cfg))
  quit(0)

when not(defined(noRofi)):
  if theme == "rofi":
    if not "rofi".inPath():
      logError("Could not find rofi in your PATH")
      quit(1)
    var cmd = execCmdEx("tsuki list | rofi -dmenu -i -p 'Theme'")
    if cmd.exitCode == 1:
      quit(1)
    theme = cmd.output.strip()

if theme == "flip":
  if themes.len != 2:
    logError("You have more than the maximum of 2 themes to use automatic theme switching, please specify a theme manually.")
    quit(1)
  var cache = readFile(confDir / ".cache" / "current-theme")
  if cache == "":
    logError("No theme has been cached, please manually specify a theme before you use the flip command")
  theme = other(themes, cache)

if not (theme in themes):
  logError("That is not a valid theme, try running 'tsuki list' to list valid themes")

createDir(confDir / ".cache")
writeFile(confDir / ".cache" / "current-theme", theme)
echo "Cached current theme!"

for file in cfg.files:
  var srcFile = confDir / "themes" / file.src.replace("*", theme)
  var destFile = file.dest.replace("~", getHomeDir()).replace("//", "/")
  if not fileExists srcFile:
    logError("Source file '" & srcFile & "' doesn't exist, please edit you themes file.")
    continue
  removeFile(destFile)
  createHardlink(srcFile, destFile)
  echo srcFile & " => " & destFile

for command in cfg.commands:
  discard execShellCmd(command)

