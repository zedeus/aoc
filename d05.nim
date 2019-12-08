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

  Program* = ref object
    mem*: seq[int]
    args*: seq[int]
    outs*: seq[int]
    halted*: bool
    ip, argp: int

proc `[]`(prog: Program; i: int): int = prog.mem[i]
proc `[]=`(prog: Program; i, v: int) = prog.mem[i] = v

proc nextOp(prog: Program): Operation =
  template setOp(op, count) =
    result.opcode = op
    result.args = newSeq[int](count)

  let op = prog[prog.ip]
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
      result.args[i - 1] = prog[prog.ip + i]
    else:
      result.args[i - 1] = prog[prog[prog.ip + i]]

proc compute*(prog: Program; args: varargs[int]) =
  if prog.halted: return
  prog.args.add @args
  while prog.ip < prog.mem.high:
    let op = prog.nextOp()
    case op.opcode
    of Add:
      prog[op.args[2]] = op.args[0] + op.args[1]
    of Multi:
      prog[op.args[2]] = op.args[0] * op.args[1]
    of Less:
      prog[op.args[2]] = int(op.args[0] < op.args[1])
    of Equal:
      prog[op.args[2]] = int(op.args[0] == op.args[1])
    of JmpT:
      if op.args[0] != 0: prog.ip = op.args[1]; continue
    of JmpF:
      if op.args[0] == 0: prog.ip = op.args[1]; continue
    of Input:
      if prog.argp == prog.args.len: return
      prog[op.args[0]] = prog.args[prog.argp]; prog.argp.inc
    of Output:
      prog.outs.add prog[op.args[0]]
    of Halt:
      prog.halted = true; break

    prog.ip.inc op.args.len + 1

when isMainModule:
  let
    input = readFile("inputs"/"05").strip.split(",").map(parseInt)
    part1 = Program(mem: input)
    part2 = Program(mem: input)
  compute(part1, 1)
  compute(part2, 5)
  echo "part1: ", part1.outs[^1]
  echo "part2: ", part2.outs[^1]
