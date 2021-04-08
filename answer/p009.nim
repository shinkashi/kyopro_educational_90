import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables, complex, times


proc solve(N: int; X, Y: seq[float]): float =
  # dump (N, X, Y)

  var deg = float.high

  # choose a pivot
  for pivot in 0..<N:

    # convert to polar coordination
    var P: seq[float]
    for i in 0..<N:
      if i == pivot: continue
      let c = complex64(X[i]-X[pivot], Y[i]-Y[pivot])
      P.add(c.phase())

    P.sort()
    # dump P.mapIt(it / PI * 180)

    for a in 0..<P.len:
      var b = P.upperBound(P[a] + PI)
      if b >= P.len: b = P.len-1
      var cur: float

      cur = P[b] - P[a]
      if abs(deg-PI) > abs(cur-PI): deg = cur

      b.dec()
      cur = P[b] - P[a]
      if abs(deg-PI) > abs(cur-PI): deg = cur

    # var a = 0
    # var b = P.len-1
    # while a < P.len and b >= 0:
    #   var curDeg = P[b] - P[a]
    #   if curDeg > PI: curDeg = 2*PI - curDeg
    #   if abs(deg - PI) > abs(curDeg - PI): deg = curDeg
    #   if curDeg < PI:
    #     a += 1
    #   else:
    #     b -= 1

  if deg > PI: deg = 2*PI - deg
  return deg / PI * 180


#---------------------------------------------------
proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0, 0)

proc parseTestCase =
  var
    caseType: string
    caseNum: string
  var
    N: int
    X, Y: seq[float]
    output: float

  var f = readFile("sample/009.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):

    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue

    lines.delete(0, 0)

    case caseType:
      of "入力例":
        N = lines.shift.parseInt
        X.setLen(0)
        Y.setLen(0)
        for i, ln in lines:
          var x, y: float
          (x, y) = ln.splitWhitespace.map(parseFloat)
          X.add(x)
          Y.add(y)

      of "出力例":
        output = lines.shift.parseFloat

        styledEcho(fgYellow, $ &"Test Case {caseNum}:")

        var res = solve(N, X, Y)

        if abs(res - output) < 10e-8:
          styledEcho(fgGreen, "PASS")
        else:
          styledEcho(fgRed, "FAIL ")
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
  echo "Finished tests"

parseTestCase()

proc bigChallenge =
  template benchmark(benchmarkName: string; code: untyped) =
    block:
      let t0 = epochTime()
      code
      let elapsed = epochTime() - t0
      let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
      echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"


  let N = 2000
  var X, Y: seq[float]
  styledEcho(fgYellow, $ &"Big Challenge N = {N}")

  randomize()
  for n in 0..<N:
    X.add(rand(0..10^9).toFloat)
    Y.add(rand(0..10^9).toFloat)

  benchmark &"N = {N}":
    echo solve(N, X, Y)

bigChallenge()
