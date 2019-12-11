import strutils, sequtils, sugar, sets, tables, math, algorithm

type Pos = tuple[x, y: int]

proc angle(a, b: Pos): float =
  arctan2(float(a.y - b.y), float(a.x - b.x))

proc parse(input: seq[seq[char]]): seq[Pos] =
  for i, row in input:
    for j, c in row:
      if c != '#': continue
      result.add (j, i)

proc findBest(input: seq[Pos]): (int, int) =
  for i, x in input:
    let visible = input.filterIt(it != x).mapIt(angle(it, x)).toHashSet
    if visible.card > result[1]:
      result = (i, visible.card)

proc vaporize(input: seq[Pos]; station: Pos): int =
  var visible: Table[float, seq[Pos]]
  for a in input.filter(x => x != station):
    let t = angle(a, station)
    if t notin visible: visible[t] = @[]
    visible[t].add a

  for k, v in visible.mpairs:
    v = v.sortedByIt(abs(it.x) + abs(it.y))

  let rot = -(PI / 2)
  if rot notin visible: visible[rot] = @[]

  var angles = toSeq(visible.keys).sorted()
  angles.rotateLeft(angles.find(rot))

  var destroyed = 0
  while destroyed < 200:
    for a in angles.filter(a => visible[a].len > 0):
      let d = visible[a].pop()
      destroyed.inc
      if destroyed == 200:
        return d.x * 100 + d.y

let
  input = readFile("inputs/10").strip.splitLines.mapIt(@it)
  asteroids = parse(input)
  (idx, best) = findBest(asteroids)

echo "part1: ", best
echo "part2: ", asteroids.vaporize(asteroids[idx])
