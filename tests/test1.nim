import unittest

import dhashpkg/dhash_lib

import bigints

test "correct dhash int":
  var o = dhash_int(get_img("testimage1.jpg"))
  check $o == "240448527803586455147515013563084980994"
