import strutils, strmisc, sequtils, algorithm, terminal

type
  Pixel = enum
    pBlack, pWhite, pNone

  Image = object
    layers: seq[seq[Pixel]]
    pixels: seq[Pixel]
    width, height: int

proc parseImage(data: seq[Pixel]; width, height: int): Image =
  Image(
    width: width, height: height,
    layers: data.distribute(data.len div (width * height))
  )

proc render(image: var Image) =
  for i in 0 ..< image.width * image.height:
    for l in image.layers:
      if l[i] == pNone: continue
      image.pixels.add Pixel(l[i]); break

proc display(image: Image) =
  for i, p in image.pixels:
    case p
    of pBlack: stdout.setBackgroundColor(bgBlack)
    of pWhite: stdout.setBackgroundColor(bgWhite, bright=true)
    of pNone:  stdout.setBackgroundColor(bgDefault)
    stdout.write " "
    stdout.resetAttributes
    if (i + 1) mod image.width == 0:
      stdout.write "\n"

let input = readFile("inputs/08").strip().mapIt(parseInt($it).Pixel)
var image = input.parseImage(25, 6)
image.render()

let smallest = image.layers.sortedByIt(it.count(pBlack))[0]
echo "part1: ", smallest.count(pWhite) * smallest.count(pNone)
echo "part2:"
image.display()
