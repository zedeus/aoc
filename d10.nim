import strutils, sequtils, sugar, sets, tables, math, algorithm

type Pos = tuple[x, y: int]

proc angle(a, b: Pos): float =
  arctan2(float(a.y - b.y), float(a.x - b.x))

proc parse(input: seq[string]): seq[Pos] =
  for y, row in input:
    for x, c in row:
      if c != '#': continue
      result.add (x, y)

proc findBest(input: seq[Pos]): (int, int) =
  for i, x in input:
    let visible = input.mapIt(angle(it, x)).toHashSet
    if visible.card > result[1]:
      result = (i, visible.card)

proc vaporize(input: seq[Pos]; station: Pos): int =
  var visible: Table[float, seq[Pos]]
  for a in input:
    let t = angle(a, station)
    if t notin visible: visible[t] = @[]
    visible[t].add a

  for k, v in visible.mpairs:
    v = v.sortedByIt(it.x + it.y)

  var angles = toSeq(visible.keys).sorted()
  angles.rotateLeft(angles.find(-(PI / 2)))

  let last = visible[angles[199]][^1]
  return last.x * 100 + last.y

let
  input = readFile("inputs/10").splitLines.parse
  (idx, best) = findBest(input)

echo "part1: ", best
echo "part2: ", input.vaporize(input[idx])
