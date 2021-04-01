import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal


proc solve(N: int): seq[string] {.memoized.} =

proc parseTestCase =
  var
    caseType: string
    caseNum: string
    N: int
    output: seq[string]

  var f = readFile("../sample/002.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.strip.splitLines()

    if not (scanf(lines[0], "# $+ $+", caseType, caseNum)):
      continue

    case caseType:
      of "入力例":
        doAssert scanf(lines[1], "$i", N)
      of "出力例":
        output = lines[1..^1]
        stdout.write &"Test Case {caseNum}: "
        var res = solve(N)
        if res == output:
          styledEcho(fgGreen, "PASS")
        else:
          styledEcho(fgRed, "FAIL ")
          styledEcho(fgCyan, "actual")
          for x in res: echo x
          styledEcho(fgCyan, "expected")
          for x in output: echo x
          styledEcho(fgDefault)

      else:
        raiseAssert("unknown caseType")

echo "START"
parseTestCase()
echo "END"
