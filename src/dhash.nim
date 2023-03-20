import argparse
import std/strutils
import imageman
import bigints

import dhashpkg/dhash_lib

export dhash_lib

when isMainModule:

  var p = newParser:
    option("-s", "--size", help="width and height of dhash image size")
    option("-f", "--format", help="hash output format, optional. Options: hex, dec Default: dec")
    arg("filename", nargs = -1, help="name of image file to hash (or two to calculate the delta)")

  var size = 8
  var filenames: seq[string]
  var format = "default"

  try:
    var opts = p.parse(commandLineParams())
    if opts.size != "":
      size = parseInt(opts.size)
    if opts.format != "":
      format = opts.format
    filenames = opts.filename
  except ShortCircuit as err:
    if err.flag == "argparse_help":
      echo err.help
      quit(1)
  except UsageError as e:
    stderr.writeLine(e.msg)
    quit(1)

  if filenames.len == 1:
    if format == "default" or format == "dec":
      echo $(dhash_int(filenames[0], size))
    elif format == "hex":
      let rowcol = dhash_row_col(filenames[0], size)
      echo format_as_hex(rowcol[0], rowcol[1])
    else:
      stderr.writeLine("Wrong format")
      quit(3)
  elif filenames.len == 2:
    if format != "default":
      stderr.writeLine("You don't use that argument here")
      quit(3)
    let hash1 = dhash_int(filenames[0], size)
    let hash2 = dhash_int(filenames[1], size)
    let diff_count = get_num_bits_different(hash1, hash2)
    echo diff_count, " bits differ"
  else:
    stderr.writeLine("You can only specify one or two filenames")
    quit(3)
