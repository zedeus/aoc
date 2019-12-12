import strutils, sequtils, math

type
  Vec = tuple[x, y, z: int]

  Moon = ref object
    pos, vel: Vec

proc pot(v: Vec): int = abs(v.x) + abs(v.y) + abs(v.z)

proc parse(input: seq[string]): seq[Moon] =
  for l in input:
    var moon = Moon()
    for c in l[1 ..< ^1].split(", "):
      case c[0]
      of 'x': moon.pos.x = c[2 .. ^1].parseInt
      of 'y': moon.pos.y = c[2 .. ^1].parseInt
      of 'z': moon.pos.z = c[2 .. ^1].parseInt
      else: discard
    result.add moon

proc step(input: seq[Moon]) =
  for m in input:
    for it in input:
      if it == m: continue
      m.vel.x.inc sgn(it.pos.x - m.pos.x)
      m.vel.y.inc sgn(it.pos.y - m.pos.y)
      m.vel.z.inc sgn(it.pos.z - m.pos.z)

  for m in input:
    m.pos.x.inc m.vel.x
    m.pos.y.inc m.vel.y
    m.pos.z.inc m.vel.z

let
  moons = readFile("inputs/12").splitLines.parse
  initX = moons.mapIt((it.pos.x, it.vel.x))
  initY = moons.mapIt((it.pos.y, it.vel.y))
  initZ = moons.mapIt((it.pos.z, it.vel.z))

var
  steps = 0
  energy = 0
  cX, cY, cZ = 0

while cX == 0 or cY == 0 or cZ == 0:
  steps.inc
  moons.step()

  if steps == 1000:
    energy = sum moons.mapIt(pot(it.pos) * pot(it.vel))

  if moons.mapIt((it.pos.x, it.vel.x)) == initX: cX = steps
  if moons.mapIt((it.pos.y, it.vel.y)) == initY: cY = steps
  if moons.mapIt((it.pos.z, it.vel.z)) == initZ: cZ = steps

echo "part1: ", energy
echo "part2: ", lcm([cX, cY, cZ])
