import os, strutils, sequtils

let input = readFile("inputs"/"02").split(",").mapIt(strip(it).parseInt)

template opStore(op) =
  let
    a = mem[i + 1]
    b = mem[i + 2]
    o = mem[i + 3]
  mem[o] = op(mem[a], mem[b])

proc compute(inputMem: seq[int]; noun, verb: int): int =
  var mem = inputMem
  mem[1] = noun
  mem[2] = verb

  for i in countup(0, mem.high, step=4):
    case mem[i]
    of 1: opStore(`+`)
    of 2: opStore(`*`)
    of 99: break
    else: discard

  return mem[0]

echo "part1: ", compute(input, 12, 2)

for noun in 0 ..< 100:
  for verb in 0 ..< 100:
    if compute(input, noun, verb) == 19690720:
      echo "part2: ", 100 * noun + verb
      quit()
