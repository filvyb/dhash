# Package

version       = "2.0.0"
author        = "Filip Vybihal"
description   = "Implementation of Neal Krawetz’s dHash algorithm in Nim"
license       = "LGPL-3.0-or-later"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["dhash"]


# Dependencies

requires "nim >= 1.6.0"
requires "imageman >= 0.8.2"
requires "argparse >= 4.0.1"
requires "bigints#head"
