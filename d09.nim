import strutils, sequtils, tables
import d05

let input = readFile("inputs/09").strip.split(",").map(parseInt)

proc runTest(input: seq[int]; arg: int): string =
  var prog = newProgram(input)
  compute(prog, arg)
  prog.outs.join(", ")

echo "part1: ", input.runTest(1)
echo "part2: ", input.runTest(2)
