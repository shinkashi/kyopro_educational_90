import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

proc solve(S: string): int =
  var T = "atcoder"
  var dp = newSeqWith(T.len, newSeqWith(S.len, 0))

  for j in 0..<S.len:
    dp[0][j] = if S[j] == T[0]: 1 else: 0

  for j in 0..<S.len:
    for i in 0..<T.len:
      if S[j] == T[i]:
        if i > 0 and j > 0: dp[i][j] += dp[i-1][j-1]

      if j > 0: dp[i][j] += dp[i][j-1]

  if S.len < 30:
    for i, x in dp: echo dp[i]

  return dp[T.len-1][S.len-1]

#---------------------------------------------------
proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0, 0)

proc parseTestCase =
  var
    caseType: string
    caseNum: string
  var
    S: string
    output: int

  var f = readFile("sample/008.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):

    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue

    lines.delete(0, 0)

    case caseType:
      of "入力例":
        S = lines.shift

      of "出力例":
        output = lines.shift.parseInt

        styledEcho(fgYellow, $ &"Test Case {caseNum}:")

        var res = solve(S)

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

          break

      else:
        raiseAssert(&"unknown caseType: {caseType}")
  echo "Finished tests"

parseTestCase()
