import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

proc solve(N, B, K: int; C: seq[int]): int =

  proc calcMods(b: int): seq[int] =
    var m = 1
    for i in 1..30:
      m = m mod b
      # if result.len > 2 and m == result[1]:
      #   break
      # dump (b, i, m)
      result.add(m)
      m = m * 10

  proc getMod(m: seq[int]; i: int): int = m[i]
    # if i < m.len - 1: return m[i]
    # return m[((i - 1) mod (m.len - 1)) + 1]

  var m = calcMods(B)
  dump m

  # for i in 0..10:
  #   dump (i, getMod(m, i))

  var cnt = 0
  var c = C

    var sum = n0 * m[0] + n1 * m[1] + n2 * m[2] + n3 * m[3] + n4 * m[4]
    if sum mod B == 0:
      # echo n2, n1, n0
      cnt += 1

  cnt

proc parseTestCase =
  var
    caseType: string
    caseNum: string

  var N, B, K: int
  var C: seq[int]

  var f = readFile("../sample/005.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue
    lines.delete(0, 0)

    case caseType:
      of "入力例":
        doAssert scanf(lines[0], "$i $i $i", N, B, K)
        lines.delete(0, 0)

        C = lines[0].splitWhitespace.map(parseInt)
        lines.delete(0, 0)

      of "出力例":
        var output: int

        doAssert scanf(lines[0], "$i", output)
        lines.delete(0, 0)

        styledEcho(fgYellow, &"Test Case {caseNum}:")

        var res = solve(N, B, K, C)

        if res == output:
          styledEcho(fgGreen, "PASS")
        else:
          styledEcho(fgRed, "FAIL ")
          styledEcho(fgCyan, "actual")
          echo res
          # for x in res: echo x
          styledEcho(fgCyan, "expected")
          echo output
          # for x in output: echo x
          styledEcho(fgDefault)

          # break

      else:
        raiseAssert(&"unknown caseType: {caseType}")
  echo "Finished tests"

parseTestCase()
