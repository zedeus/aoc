import strutils, sequtils
import d05

type
  Cell = enum
    cEmpty, cWall, cBlock, cPaddle, cBall

proc playGame(mem: seq[int]): tuple[b, s: int] =
  let prog = newProgram(mem)
  var input = 0

  while not prog.halted:
    prog.compute(input)

    var ball, paddle, blocks = 0
    for p in countup(0, prog.outs.high, step=3):
      let x = prog.outs[p]

      if prog.outs[p + 2] == 0: continue

      if x == -1 and prog.outs[p + 1] == 0:
        result.s = prog.outs[p + 2]

      case Cell(prog.outs[p + 2])
      of cBall: ball = x
      of cPaddle: paddle = x
      of cBlock:
        if result.b == 0: blocks.inc
      else: discard

    input = cmp(ball, paddle)

    if result.b == 0:
      result.b = blocks

var input = readFile("inputs/13").strip.split(",").map(parseInt)
input[0] = 2

let (blocks, score) = input.playGame()
echo "part1: ", blocks
echo "part2: ", score
