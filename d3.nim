import os, strutils, sequtils

proc tracePath(path: seq[string]): seq[(int, int)] =
  var (x, y) = (0, 0)
  for line in path:
    for i in 0 ..< parseInt(line[1 .. ^1]):
      case line[0]
      of 'R': x.inc
      of 'L': x.dec
      of 'U': y.inc
      of 'D': y.dec
      else: discard
      result.add (x, y)

let
  input = toSeq(lines("inputs"/"03")).mapIt(it.split(","))
  aPath = tracePath(input[0])
  bPath = tracePath(input[1])
  crosses = aPath.filterIt(it in bPath)

var closest = int.high
for (x, y) in deduplicate(crosses):
  let dist = abs(x + y)
  if dist < closest:
    closest = dist
    echo dist
echo "par1 (maybe): ", closest
# sometimes it's the second closest, not sure why

var bestCross = int.high
for cross in crosses:
  var (a, b) = (aPath.find(cross), bPath.find(cross))
  if a + b < bestCross:
    bestCross = a + b
echo "part2: ", bestCross + 2
