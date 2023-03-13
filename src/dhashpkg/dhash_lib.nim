import imageman
import bigints

import std/strutils

## Loads picture from a path and returns it
proc get_img*(path: string): Image[ColorRGBU] =
  result = loadImage[ColorRGBU](path)

## Converts image to grayscale, downsizes it to width*height, and returns list
## of it's grayscale integer pixel values
proc get_grays(image: Image[ColorRGBU], width, height: int): seq[uint8] =
  var gimg = image.resizedBicubic(width, height)
  filterGreyscale(gimg)
  for pixel in gimg.data.mitems:
    result &= pixel.r

## Calculates row and column difference hash for given image and returns
## hashes as (row_hash, col_hash) where each value is a size*size bit integer
proc dhash_row_col*(image: Image[ColorRGBU], size: int): (BigInt, BigInt) =
  let width = size + 1
  let grays = get_grays(image, width, width)

  var row_hash = initBigInt(0)
  var col_hash = initBigInt(0)
  for y in 0..size-1:
    for x in 0..size-1:
      var offset = y * width + x
      var row_bit = grays[offset] < grays[offset + 1]
      row_hash = row_hash shl 1 or initBigInt(uint64(row_bit))

      var col_bit = grays[offset] < grays[offset + width]
      col_hash = col_hash shl 1 or initBigInt(uint64(col_bit))
  
  result = (row_hash, col_hash)

## Calculates row and column difference hash for given image and returns
## hashes combined as a single 2*size*size bit integer
proc dhash_int*(image: Image[ColorRGBU], size=8): BigInt =
  let calc = dhash_row_col(image, size)
  let row_hash = calc[0]
  let col_hash = calc[1]

  result = initBigInt(row_hash) shl (size * size) or initBigInt(col_hash)

## Returns formatted dhash integers as hex string
proc format_as_hex*(row_hash, col_hash: BigInt): string =
  #var hex_length = floorDiv(size * size, 4)
  result = $row_hash.toString(16) & $col_hash.toString(16)

## Returns number of bits different between two given hashes
proc get_num_bits_different*(hash1, hash2: BigInt): int =
  var diff = hash1 xor hash2
  result = toString(diff, 2).count('1')
