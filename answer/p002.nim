import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal


proc solve(N: int): seq[string] {.memoized.} =
  if N < 2: return @[]
  if N == 2: return @["()"]
  result.add solve(N-2).mapIt(&"({it})")
  for n in countdown(N - 2, 2, 2):
    var a = solve(n)
    var b = solve(N - n)
    var res = product(@[a, b]).mapIt(it[0] & it[1])
    result.add(res)

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
