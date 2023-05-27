import os, terminal

type
  File* = object
    dest*: string
    src*: string
  Themes* = object
    files*: seq[lib.File]
    commands*: seq[string]

proc listDirs*(parentDir: string): seq[string] =
  for file in walkDir(parentDir):
    if file.kind == PathComponent.pcDir:
      result.add(file.path.splitPath().tail)

proc logError*(error: string) =
  stdout.styledWriteLine(fgRed, "Error:", fgWhite, " " & error)
