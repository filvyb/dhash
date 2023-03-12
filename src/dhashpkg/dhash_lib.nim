import imageman
import nint128

import std/strformat
import std/math


proc get_img*(path: string): Image[ColorRGBU] =
  result = loadImage[ColorRGBU](path)

proc get_grays(image: Image[ColorRGBU], width: int, height: int): seq[uint8] =
  var gimg = image.resizedBicubic(width, height)
  filterGreyscale(gimg)
  for pixel in gimg.data.mitems:
    result &= pixel.r


proc dhash_row_col(image: Image[ColorRGBU], size: int): (uint64, uint64) =
  let width = size + 1
  let grays = get_grays(image, width, width)

  var row_hash: uint64 = 0
  var col_hash: uint64 = 0
  for y in 0..size-1:
    for x in 0..size-1:
      var offset = y * width + x
      var row_bit = grays[offset] < grays[offset + 1]
      row_hash = row_hash shl 1 or uint64(row_bit)

      var col_bit = grays[offset] < grays[offset + width]
      col_hash = col_hash shl 1 or uint64(col_bit)
  
  result = (row_hash, col_hash)


proc dhash_int*(image: Image[ColorRGBU], size=8): UInt128 =
  if size > 8:
    stderr.writeLine("Size can't be over 8 due to size of integer")
    quit(2)

  let calc = dhash_row_col(image, size)
  let row_hash = calc[0]
  let col_hash = calc[1]

  result = u128(row_hash) shl (size * size) or u128(col_hash)

proc format_hex*(row_hash: uint64, col_hash: uint64, size=8): string =
  if size > 8:
    stderr.writeLine("Size can't be over 8 due to size of integer")
    quit(2)

  var hex_length = floorDiv(size * size, 4)
  #result = fmt"{row_hash:0{hex_length}x}{col_hash:0{hex_length}x}"
