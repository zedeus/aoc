import strutils, sequtils, math, sets
import d05

type
  Cell = enum
    cBlack = " ", cWhite = "█"

  Grid = ref object
    cells: seq[Cell]
    w, h: int

  Pos = tuple[x, y: int]
  Dir = enum N, E, S, W

  Robot = ref object
    dir: Dir
    pos: Pos

proc `[]`(grid: Grid; p: Pos): Cell =
  grid.cells[p.x + p.y * grid.h]

proc `[]=`(grid: Grid; p: Pos; c: Cell) =
  grid.cells[p.x + p.y * grid.h] = c

proc draw(grid: Grid) =
  for y in 0 ..< grid.h:
    let row = grid.cells[y * grid.h ..< (y + 1) * grid.h]
    if cWhite in row:
      echo row.join()

proc step(r: Robot; dir: int) =
  let s = if dir == 1: 1 else: -1
  r.dir = Dir(floorMod(r.dir.ord + s, 4))

  case r.dir
  of N: r.pos.y -= 1
  of S: r.pos.y += 1
  of E: r.pos.x += 1
  of W: r.pos.x -= 1

proc paintHull(mem: seq[int]; startTile: Cell; w: int; draw=false) =
  var
    prog = newProgram(mem)
    grid = Grid(w: w, h: w, cells: newSeq[Cell](w * w))
    robot = Robot(pos: (0, w div 2))
    tiles: HashSet[Pos]

  grid[robot.pos] = startTile

  while not prog.halted:
    prog.compute(grid[robot.pos].ord)
    grid[robot.pos] = Cell(prog.outs[^2])
    robot.step(prog.outs[^1])
    tiles.incl robot.pos

  if draw: grid.draw()
  else: echo tiles.card

let input = readFile("inputs/11").strip.split(",").map(parseInt)

stdout.write "part1: "
input.paintHull(cBlack, 100)
echo "part2: "
input.paintHull(cWhite, 42, draw=true)
