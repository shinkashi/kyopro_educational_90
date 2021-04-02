import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

const MAX = int.high div 10

## 1. Get diameter by doing dfs twice

func solve(H, W: int, A: seq[seq[int]]): seq[seq[int]] =
  var B = newSeqWith(H, newSeqWith(W, 0))
  var R = newSeqWith(H, 0)
  var C = newSeqWith(W, 0)
  for h in 0..<H:
    for w in 0..<W:
      R[h] += A[h][w]
      C[w] += A[h][w]

  for h in 0..<H:
    for w in 0..<W:
      B[h][w] = R[h] + C[w] - A[h][w]

  return B

proc parseTestCase =
  var
    caseType: string
    caseNum: string

  var H, W: int
  var A: seq[seq[int]]

  var f = readFile("../sample/004.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):




      continue
    lines.delete(0, 0)

    case caseType:
      of "入力例":
        doAssert scanf(lines[0], "$i $i", H, W)
        lines.delete(0, 0)
        A = newSeqWith(H, newSeqWith(W, 0))

        for h in 0..<H:
          A[h] = lines[0].splitWhitespace.map(parseInt)
          lines.delete(0, 0)

      of "出力例":
        var output = newSeqWith(H, newSeqWith(W, 0))

        for h in 0..<H:
          output[h] = lines[0].splitWhitespace.map(parseInt)
          lines.delete(0, 0)

        styledEcho(fgYellow, &"Test Case {caseNum}:")

        var res = solve(H, W, A)

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
