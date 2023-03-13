# dhash
dhash is a Nim library and CLI program that generates a perceptual hash for a given image based on [Neal Krawetz’s blog post](https://www.hackerfactor.com/blog/index.php?/archives/529-Kind-of-Like-That.html) on dHash algorithm


## Usage
As library
```nim
import imageman
import bigints
import dhash

let image1 = get_img("path/to/image")
let hash1 = dhash_int(image1)
```

As a binary 
```bash
dhash path/to/image
```
