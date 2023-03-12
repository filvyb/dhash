# dhash
dhash is a Nim library and CLI program that generates a perceptual hash for a given image based on [Neal Krawetz’s blog post](https://www.hackerfactor.com/blog/index.php?/archives/529-Kind-of-Like-That.html) on dHash algorithm

The final hash can't be larger than 128-bit due to Nim's limitations

## Usage
As library
```nim
import imageman
import nint128
import dhash_lib

let image1 = get_img("path/to/image")
let hash1 = dhash_int(image1)
```

As a binary 
```bash
dhash path/to/image
```
