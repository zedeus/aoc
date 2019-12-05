import os, strutils, sequtils, algorithm

type
  Opcode = enum
    Add, Multi,
    Input, Output,
    JmpT, JmpF,
    Less, Equal,
    Halt

  Operation = object
    opcode: Opcode
    args: seq[int]

proc parseOp(mem: seq[int]; ip: int): Operation =
  template setOp(op, count) =
    result.opcode = op
    result.args = newSeq[int](count)

  let op = mem[ip]
  case op mod 10
  of 1: setOp(Add, 3)
  of 2: setOp(Multi, 3)
  of 3: setOp(Input, 1)
  of 4: setOp(Output, 1)
  of 5: setOp(JmpT, 2)
  of 6: setOp(JmpF, 2)
  of 7: setOp(Less, 3)
  of 8: setOp(Equal, 3)
  else: setOp(Halt, 0)

  let sip = @($op).reversed()
  for i in 1 .. result.args.len:
    if (result.opcode notin {JmpT, JmpF} and i >= result.args.len) or
       sip.len >= i + 2 and sip[i + 1] == '1':
      result.args[i - 1] = mem[ip + i]
    else:
      result.args[i - 1] = mem[mem[ip + i]]

proc compute(inputMem: seq[int]) =
  var mem = inputMem

  var ip = 0
  while ip < mem.high:
    let op = mem.parseOp(ip)
    ip.inc op.args.len + 1

    case op.opcode
    of Add:
      mem[op.args[2]] = op.args[0] + op.args[1]
    of Multi:
      mem[op.args[2]] = op.args[0] * op.args[1]
    of Less:
      mem[op.args[2]] = if op.args[0] < op.args[1]: 1 else: 0
    of Equal:
      mem[op.args[2]] = if op.args[0] == op.args[1]: 1 else: 0
    of Input:
      stdout.write("Input: ")
      mem[op.args[0]] = stdin.readLine().parseInt
    of Output:
      echo mem[op.args[0]]
    of JmpT:
      if op.args[0] != 0: ip = op.args[1]
    of JmpF:
      if op.args[0] == 0: ip = op.args[1]
    of Halt:
      break

let input = readFile("inputs"/"05").strip.split(",").map(parseInt)
compute(input)
