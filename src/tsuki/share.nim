import os, strutils

proc inPath*(target: string): bool =
  var path = getEnv("PATH").split(":")
  for dir in path:
    for file in walkDirRec(dir):
      if file.extractFilename() == target:
        return true
  return false
