import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables, complex, times


proc solve(N, Q: int; C, P, L, R: seq[int]): seq[(int, int)] =
  # dump (C, P, L, R)

  var acc: array[1..2, seq[int]]
  acc[1].add(0)
  acc[2].add(0)
  acc[1].setLen(N+1)
  acc[2].setLen(N+1)
  for i in 0..<N:
    acc[1][i+1] = acc[1][i] + (if C[i] == 1: P[i] else: 0)
    acc[2][i+1] = acc[2][i] + (if C[i] == 2: P[i] else: 0)

  for i in 0..<Q:
    var res1 = acc[1][R[i]] - acc[1][L[i]-1]
    var res2 = acc[2][R[i]] - acc[2][L[i]-1]
    result.add((res1, res2))

#---------------------------------------------------
proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0, 0)

proc parseTestCase =
  var
    caseType: string
    caseNum: string
  var
    N, Q: int
    C, P, L, R: seq[int]
    output: seq[(int, int)]

  var f = readFile("sample/010.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):

    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue

    lines.delete(0, 0)

    case caseType:
      of "入力例":
        N = lines.shift.parseInt
        C.setLen(N)
        P.setLen(N)
        for i in 0..<N:
          (C[i], P[i]) = lines.shift.splitWhitespace.map(parseInt)
        Q = lines.shift.parseInt

        L.setLen(Q)
        R.setLen(Q)
        for i in 0..<Q:
          (L[i], R[i]) = lines.shift.splitWhitespace.map(parseInt)

      of "出力例":
        output.setLen(Q)
        for i in 0..<Q:
          doAssert scanf(lines.shift, "$i $i", output[i][0], output[i][1])

        styledEcho(fgYellow, $ &"Test Case {caseNum}:")

        var res = solve(N, Q, C, P, L, R)

        # if abs(res - output) < 10e-8:
        if res == output:
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
