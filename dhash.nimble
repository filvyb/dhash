# Package

version       = "0.1.0"
author        = "Filip Vybihal"
description   = "Implementation of Neal Krawetz’s dHash algorithm in Nim"
license       = "LGPL-3.0-or-later"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["dhash"]


# Dependencies

requires "nim >= 1.6.10"
requires "imageman >= 0.8.2"
