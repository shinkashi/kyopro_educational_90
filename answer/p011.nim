import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables, complex, times

#---------------------------------------------------

proc solve(N: int; D, C, S: var seq[int]): int =
  # sort by D
  var tmp: seq[(int, int, int)]
  for i in 1..N: tmp.add((D[i], C[i], S[i]))
  tmp.sort()
  for i in 1..N: (D[i], C[i], S[i]) = tmp[i-1]

  # dp[1-jobNum][totalTime] = max revenue
  var dmax = D.max
  var dp = newSeqWith(N+1, newSeqWith(dmax+1, 0))
  for i in 1..N:
    for j in 0..dmax:
      if C[i] <= j and j <= D[i]:
        dp[i][j] = max(dp[i-1][j], dp[i-1][j-C[i]] + S[i])
      else:
        dp[i][j] = dp[i-1][j]

  return dp[N].max

proc solve_DFS(N: int; D, C, S: seq[int]): int =
  type Jobs = set[uint8]
  proc dfs(day: int; jobs: Jobs): int {.memoized.} =
    var revenue = 0
    for i in jobs:
      if day + C[i] <= D[i]:
        revenue = max(revenue, dfs(day + C[i], jobs - {i.uint8}) + S[i])
    return revenue

  var jobs: Jobs = {1.uint8 .. N.uint8}

  dfs(0, jobs)

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
    D, C, S: seq[int]
    output: int

  var f = readFile("sample/011.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):

    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue

    lines.delete(0, 0)

    case caseType:
      of "入力例":
        N = lines.shift.parseInt
        D.setLen(N+1)
        C.setLen(N+1)
        S.setLen(N+1)
        for i in 1..N:
          (D[i], C[i], S[i]) = lines.shift.splitWhitespace.map(parseInt)

      of "出力例":
        output = lines.shift.parseInt

        styledEcho(fgYellow, $ &"Test Case {caseNum}:")

        var res = solve(N, D, C, S)

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
