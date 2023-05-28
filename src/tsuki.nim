import lib, os, jsony, termui, strutils, json

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


if not (theme in themes):
  logError("That is not a valid theme, try running 'tsuki list' to list valid themes")

writeFile(confDir / ".cache" / "current-theme", theme)

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

