import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

const MOD = 10 ^ 9 + 7

type Matrix = seq[seq[int]]

proc `*`(A, B: Matrix): Matrix =
  # A[m][n], B[n][p]

  assert A[0].len == B.len

  let
    m = A.len
    n = A[0].len
    p = B[0].len

  result = newSeqWith(m, newSeqWith(p, 0))

  for i in 0..<m:
    for j in 0..<p:
      for k in 0..<n:
        result[i][j] += A[i][k] * B[k][j]
        result[i][j] = result[i][j] mod MOD

proc prepPowerTable(A: Matrix): seq[Matrix] =
  var A = A
  for i in 0..63:
    result.add(A)
    dump (i)
    A = A * A

proc power(A: Matrix, T: int, powerTable: seq[Matrix]): Matrix =
  var m = A.len
  result = newSeqWith(m, newSeqWith(m, 0))
  for i in 0..<m: result[i][i] = 1

  for i in 0..<powerTable.len:
    if (T and (1 shl i)) != 0:
      result = powerTable[i] * result


proc solve(N, B, K: int; C: seq[int]): int =

  # dp[桁数][現時点でのBで割った余り] = 何通り
  dump (N, B, K, C)

  # build matrix A
  var A: Matrix = newSeqWith(B, newSeqWith(B, 0))
  for j in 0..<B:
    for c in C:
      let nex = (10 * j + c) mod B
      A[j][nex] += 1

  # build matrix dp
  var dp = newSeqWith(B, @[0])
  dp[0][0] = 1

  echo "calculating pt"
  var pt = prepPowerTable(A)
  echo "calculating power"
  dp = power(A, N, pt) * dp

  return dp[0][0]

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
