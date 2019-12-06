import strutils, strmisc, sequtils

type
  Body = ref object
    name: string
    orbits: seq[Body]

proc findBody(body: Body; name: string): Body =
  if body.name == name: return body
  for orbit in body.orbits:
    let found = orbit.findBody(name)
    if found != nil:
      return found

proc parseOrbitMap(input: seq[string]): Body =
  var orphans: seq[Body]
  result = Body(name: "COM")

  for orbit in input:
    let (parent, _, child) = orbit.partition(")")
    var body = result.findBody(parent)

    let orphan = orphans.mapIt(it.findBody(parent)).filterIt(it != nil)
    if orphan.len == 1:
      body = orphan[0]

    if body == nil:
      body = Body(name: parent)
      orphans.add body

    let childOrphan = orphans.filterIt(it.name == child)
    if childOrphan.len == 1:
      body.orbits.add childOrphan[0]
      orphans.keepItIf(it.name != child)
    else:
      body.orbits.add Body(name: child)

proc countBodies(body: Body; depth=1): int =
  for orbit in body.orbits:
    result.inc depth
    result.inc countBodies(orbit, depth + 1)

proc getBodyList(body: Body; name: string): seq[string] =
  for orbit in body.orbits:
    if orbit.name == name: return @[""]
    let found = orbit.getBodyList(name)
    if found.len > 0:
      return orbit.name & found

let
  input = readFile("inputs/06").strip().splitLines
  orbitMap = parseOrbitMap(input)
  you = orbitMap.getBodyList("YOU")
  san = orbitMap.getBodyList("SAN")
  common = you.filterIt(it in san).high

echo "part1: ", countBodies(orbitMap)
echo "part2: ", you.high + san.high - common * 2
