# Package

version = "1.0.0"
author = "Licorice"
description = "A fast opinionated theme switcher and template engine"
license = "GPL-3.0-only"
srcDir = "src"
bin = @["tsuki"]
binDir = "bin"

# Dependencies

requires "nim >= 2.0.0", "therapist", "https://github.com/yummy-licorice/moustachu", "kdl"

task make, "make":
  exec "nimble build -d:release --verbose"
  exec "sudo cp bin/tsuki /usr/local/bin"
