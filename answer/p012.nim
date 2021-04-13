import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables, complex, times

#---------------------------------------------------
proc solve(H, W, Q: int; X, Y: seq[int]; XA, YA, XB, YB: int): string =

  type Color = enum White, Red

  var board = newSeqWith(H+1, newSeqWith(W+1, White))
  for (x, y) in zip(X, Y): board[y][x] = Red

  proc isWalkable(xa, ya, xb, yb: int): bool =
    var visited = newSeqWith(H+1, newSeqWith(W+1, false))

    proc walk(x, y: int): bool =
      visited[y][x] = true
      if x == xb and y == yb:
        if board[yb][xb] == Red:
          return true

      const dir = [0, 1, 0, -1, 0]
      for i in 0..dir.len-2:
        var (dy, dx) = (dir[i], dir[i+1])
        var nx = x + dx
        var ny = y + dy
        if nx < 1 or nx > W: continue
        if ny < 1 or ny > H: continue
        if visited[ny][nx]: continue
        if board[ny][nx] == White: continue
        if nx == xb and ny == yb: return true
        if walk(nx, ny): return true

      return false

    return walk(xa, ya)

  result = if isWalkable(XA, YA, XB, YB): "Yes" else: "No"

#---------------------------------------------------
proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0, 0)

proc parseTestCase =
  var
    caseType: string
    caseNum: string
  var
    H, W, Q: int
    X, Y, XA, YA, XB, YB: seq[int]
    res, output: seq[string]

  var f = readFile("sample/012.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):

    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue
    lines.delete(0)

    case caseType:
      of "入力例":
        styledEcho(fgYellow, $ &"Test Case {caseNum}:")

        (H, W) = lines.shift.splitWhitespace.map(parseInt)
        Q = lines.shift.parseInt
        X = @[]
        Y = @[]
        res = @[]

        for i in 1..Q:
          var ln = lines.shift.splitWhitespace.map(parseInt)
          case ln[0]
          of 1:
            X.add(ln[1])
            Y.add(ln[2])
          of 2:
            var XA = ln[1]
            var YA = ln[2]
            var XB = ln[3]
            var YB = ln[4]
            res.add solve(H, W, Q, X, Y, XA, YA, XB, YB)

          else:
            raiseAssert("unknown type")

      of "出力例":
        output = lines.filterIt(it.match(re"^Yes|No"))

        # if abs(res - output) < 10e-8:
        if res == output:
          styledEcho(fgGreen, "PASS")
        else:
          styledEcho(fgRed, "FAIL")
          styledEcho(fgCyan, "actual")

          when res is seq:
            for x in res: echo x
          else:
            echo res

          styledEcho(fgCyan, "expected")
          when output is seq:
            for x in output: echo x
          else:
            echo output

          styledEcho(fgDefault)

          # break

      else:
        raiseAssert(&"unknown caseType: {caseType}")
  echo "Finished tests " & $now()

parseTestCase()

# proc bigChallenge =
#   template benchmark(benchmarkName: string; code: untyped) =
#     block:
#       let t0 = epochTime()
#       code
#       let elapsed = epochTime() - t0
#       let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
#       echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"


  # let N = 2000
  # var X, Y: seq[float]
  # styledEcho(fgYellow, $ &"Big Challenge N = {N}")

  # randomize()
  # for n in 0..<N:
  #   X.add(rand(0..10^9).toFloat)
  #   Y.add(rand(0..10^9).toFloat)

  # benchmark &"N = {N}":
  #   echo solve(N, X, Y)

# bigChallenge()
