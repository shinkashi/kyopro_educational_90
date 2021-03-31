import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math

proc solve(N: int): seq[string] =
  if N < 2: return @[]
  if N == 2: return @["()"]
  result.add solve(N-2).mapIt(&"({it})")
  for n in countup(2, N - 2, 2):
    var a = solve(n)
    var b = solve(N - n)
    var res = product(@[a, b]).mapIt(it[0] & it[1])
    result.add(res)


proc parseTestCase =
  var
    caseType: string
    caseNum: int
    N: int
    output: seq[string]

  var f = readFile("../sample/002.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.strip.splitLines()

    if not (scanf(lines[0], "# $+ $i", caseType, caseNum)):
      continue

    case caseType:
      of "入力例":
        doAssert scanf(lines[1], "$i", N)
      of "出力例":
        output = lines[1..^1]
        stdout.write &"Test Case {caseNum}: "
        var res = solve(N)
        if res == output:
          echo "PASS"
        else:
          echo &"FAIL"
          echo "actual"
          for x in res: echo x
          echo "expect"
          for x in output: echo x


      else:
        raiseAssert("unknown caseType")

echo "START"
parseTestCase()
echo "END"
