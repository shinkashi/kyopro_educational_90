import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables, complex, times, heapqueue

proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0)

#---------------------------------------------------
proc solve(N: int; A, B: var seq[int]): int =
  A.sort()
  B.sort()
  A.zip(B).mapIt(abs(it[0]-it[1])).sum

#---------------------------------------------------
proc runTestCase(testcase: string) =
  var
    N: int
    A, B: seq[int]
    res, output: int

  var testcase = testcase.replace("----------", "")
  var lines: seq[string] = testcase.strip.splitLines()

  # 入力例ヘッダを読む

  var hd: seq[string]
  hd = lines.shift.splitWhitespace

  if hd[0] != "#":
    raiseAssert("#ヘッダが見当たらない")

  if hd[1] == "入力形式":
    return

  if hd[1] != "入力例":
    raiseAssert(&"入力例が見当たらない: {hd}")

  styledEcho(fgYellow, $ &"Test Case {hd[2]}:")

  # 入力例を読む

  N = lines.shift.splitWhitespace.map(parseInt)[0]
  A = lines.shift.splitWhitespace.map(parseInt)
  B = lines.shift.splitWhitespace.map(parseInt)
  # A.insert(@[-99])
  # B.insert(@[-99])

  # 実行

  res = solve(N, A, B)

  # 出力例を読む

  while lines[0].strip == "": lines.delete(0)
  hd = lines.shift.splitWhitespace
  if hd[1] != "出力例":
    raiseAssert("出力例が見当たらない")

  output = lines.map(parseInt)[0]

  # if abs(res - output) < 10e-8:
  if res == output:
    styledEcho(fgGreen, "PASS")

  else:
    styledEcho(fgRed, "FAIL")
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


proc runAllTestCases =
  var f = readFile("sample/014.txt")
  f.add "\r\n----------"
  for testcase in f.findAll(re("# 入力例.+?----------", {reDotAll})):
    runTestCase(testcase)
  echo "Finished tests " & $now()

runAllTestCases()

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
