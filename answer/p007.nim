import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

proc solve(N: int, A: var seq[int], Q: int, B: seq[int]): seq[int] =
  # sort class rating
  A.sort()

  var total = 0

  for i in 0..<Q:
    var hi = A.lowerBound(B[i])
    dump (hi, N)

    var diff = int.high

    if hi != N:
      diff = min(diff, abs(A[hi] - B[i]))
      dump ("not N-1")

    if hi != 0:
      diff = min(diff, abs(A[hi-1] - B[i]))
      dump ("not 0")

    dump diff

    result.add(diff)

#---------------------------------------------------
proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0, 0)

proc parseTestCase =
  var
    caseType: string
    caseNum: string

  var f = readFile("sample/007.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):

    var
      N: int
      A: seq[int]
      Q: int
      B: seq[int]

    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue

    lines.delete(0, 0)

    case caseType:
      of "入力例":
        N = lines.shift.parseInt
        A = lines.shift.splitWhitespace.map(parseInt)
        Q = lines.shift.parseInt

        for i in 0..<Q:
          B.add(lines.shift.parseInt)

      of "出力例":
        var output: seq[int]

        for i in 0..<Q:
          output.add(lines.shift.parseInt)

        styledEcho(fgYellow, &"Test Case {caseNum}:")

        var res = solve(N, A, Q, B)

        if res == output:
          styledEcho(fgGreen, "PASS")
        else:
          styledEcho(fgRed, "FAIL ")
          styledEcho(fgCyan, "actual")
          # echo res
          for x in res: echo x
          styledEcho(fgCyan, "expected")
          # echo output
          for x in output: echo x
          styledEcho(fgDefault)

          break

      else:
        raiseAssert(&"unknown caseType: {caseType}")
  echo "Finished tests"

parseTestCase()
