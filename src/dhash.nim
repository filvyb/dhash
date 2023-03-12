import argparse
import std/strutils
import imageman
import nint128

import dhashpkg/dhash_lib

export dhash_lib

when isMainModule:

  var p = newParser:
    option("-s", "--size", help="width and height of dhash image size")
    arg("filename")

  var size = 8
  var filename = ""

  try:
    var opts = p.parse(commandLineParams())
    if opts.size != "":
      size = parseInt(opts.size)
    filename = opts.filename
  except ShortCircuit as err:
    if err.flag == "argparse_help":
      echo err.help
      quit(1)
  except UsageError as e:
    stderr.writeLine(e.msg)
    quit(1)

  echo $(dhash_int(get_img(filename), size))
