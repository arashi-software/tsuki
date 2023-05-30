# Package

version       = "1.1.0"
author        = "Luke"
description   = "My theme switching script"
license       = "GPL-3.0-or-later"
srcDir        = "src"
binDir        = "bin"
bin           = @["tsuki"]


# Dependencies

requires "nim >= 1.4.8", "jsony", "termui"
