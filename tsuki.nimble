# Package

version = "0.1.0"
author = "Licorice"
description = "A fast opinionated theme switcher and template engine"
license = "GPL-3.0-only"
srcDir = "src"
bin = @["tsuki"]
binDir = "bin"

# Dependencies

requires "nim >= 2.0.0", "therapist", "https://github.com/yummy-licorice/temple", "kdl", "npeg"
