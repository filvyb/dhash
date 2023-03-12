import argparse
import std/strutils
import imageman
import nint128

import dhashpkg/dhash_lib

export dhash_lib

when isMainModule:

  var p = newParser:
    option("-s", "--size", help="width and height of dhash image size")
    arg("filename", nargs = -1)

  var size = 8
  var filenames: seq[string]

  try:
    var opts = p.parse(commandLineParams())
    if opts.size != "":
      size = parseInt(opts.size)
    filenames = opts.filename
  except ShortCircuit as err:
    if err.flag == "argparse_help":
      echo err.help
      quit(1)
  except UsageError as e:
    stderr.writeLine(e.msg)
    quit(1)

  if filenames.len == 1:
    echo $(dhash_int(get_img(filenames[0]), size))
  elif filenames.len == 2:
    let image1 = get_img(filenames[0])
    let image2 = get_img(filenames[1])
    let hash1 = dhash_int(image1, size)
    let hash2 = dhash_int(image2, size)
    let diff_count = get_num_bits_different(hash1, hash2)
    echo diff_count, " bits differ"
  else:
    stderr.writeLine("You can only specify one or two filenames")
    quit(3)
