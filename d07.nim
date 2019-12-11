import strutils, strmisc, sequtils, algorithm
import d05

let input = readFile("inputs/07").strip().split(",").map(parseInt)

proc amplify(mem: seq[int]; phases: seq[int]): int =
  var amps = phases.mapIt(newProgram(mem, @[it]))
  var last = 0
  while amps.allIt(not it.halted):
    for amp in amps:
      compute(amp, last)
      last = amp.outs[^1]
    result = max(last, result)

proc optimizePhase(input: seq[int]; start: seq[int]): int =
  var phases = start
  while phases.nextPermutation:
    result = max(amplify(input, phases), result)

echo "part1: ", optimizePhase(input, @[0, 1, 2, 3, 4])
echo "part2: ", optimizePhase(input, @[5, 6, 7, 8, 9])
