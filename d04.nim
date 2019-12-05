import strutils, sequtils

proc isAscending(num: string): bool =
  result = true
  for d in 1 .. num.high:
    if num[d - 1] > num[d]:
      return false

proc hasPair(num: string): bool =
  var curPair = 0
  for d in 1 .. num.high:
    if num[d - 1] == num[d]:
      curPair.inc
    else:
      if curPair == 1: break
      curPair = 0
  result = curPair == 1

var nums = 0
for i in 153517 .. 630395:
  if isAscending($i) and hasPair($i):
    nums.inc

echo nums
