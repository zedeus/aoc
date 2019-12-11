import os, strutils, sequtils, algorithm, tables, math

type
  Opcode = enum
    Add, Multi,
    Input, Output,
    JmpT, JmpF,
    Less, Equal,
    RelOffset, Halt

  Operation = object
    opcode: Opcode
    args: seq[int]

  Program* = ref object
    mem*: OrderedTable[int, int]
    args*: seq[int]
    outs*: seq[int]
    halted*: bool
    ip, argp, rel: int

proc `[]`(prog: Program; i: int): int =
  if i notin prog.mem: prog.mem[i] = 0
  prog.mem[i]

proc `[]=`(prog: Program; i, v: int) =
  prog.mem[i] = v

proc newProgram*(input: seq[int]; args: varargs[int]): Program =
  Program(mem: toSeq(input.pairs()).toOrderedTable, args: @args)

proc nextOp(prog: Program): Operation =
  template setOp(op, count) =
    result.opcode = op
    result.args = newSeq[int](count)

  let op = prog[prog.ip]
  case op mod 100
  of 1: setOp(Add, 3)
  of 2: setOp(Multi, 3)
  of 3: setOp(Input, 1)
  of 4: setOp(Output, 1)
  of 5: setOp(JmpT, 2)
  of 6: setOp(JmpF, 2)
  of 7: setOp(Less, 3)
  of 8: setOp(Equal, 3)
  of 9: setOp(RelOffset, 1)
  else: setOp(Halt, 0)

  for i in 0 .. result.args.high:
    let
      ip = prog.ip + i + 1
      mode = op div 10^(i + 2) mod 10
      writes = result.opcode notin {Output, JmpF, JmpT, RelOffset}

    if mode == 2:
      result.args[i] = prog.rel + prog[ip]
    else:
      result.args[i] = prog[ip]

    if i < result.args.high or not writes and mode != 1:
      if mode != 1:
        result.args[i] = prog[result.args[i]]

proc compute*(prog: Program; args: varargs[int]) =
  if prog.halted: return
  prog.args.add @args
  while not prog.halted:
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
      prog.outs.add op.args[0]
    of RelOffset:
      prog.rel += op.args[0]
    of Halt:
      prog.halted = true; break

    prog.ip.inc op.args.len + 1

when isMainModule:
  let
    input = readFile("inputs"/"05").strip.split(",").map(parseInt)
    part1 = newProgram(input)
    part2 = newProgram(input)
  compute(part1, 1)
  compute(part2, 5)
  echo "part1: ", part1.outs[^1]
  echo "part2: ", part2.outs[^1]
