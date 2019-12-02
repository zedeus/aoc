import os, strutils, sequtils, math

proc fuelCalc(fuel: int): int = fuel div 3 - 2

proc fuelRec(fuel: int): int =
  if fuel <= 3 * 2: return
  result = fuelCalc(fuel)
  result += fuelRec(result)

let input = toSeq(lines("inputs"/"01")).map(parseInt)
echo "part1: ", input.map(fuelCalc).sum()
echo "part2: ", input.map(fuelRec).sum()
