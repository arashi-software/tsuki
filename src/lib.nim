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
  stderr.styledWriteLine(fgRed, "Error:", fgWhite, " " & error)

proc other*(list: seq[string], item: string): string =
  if not list.len == 2:
    raise newException(LibraryError, "List argument was either longer or shorter than 2 items")
  for l in list:
    if l != item:
      return l