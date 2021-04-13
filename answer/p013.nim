import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables, complex, times, heapqueue

#---------------------------------------------------

type Edge = object
  to: int
  w: int

proc solve(N, M: int; A, B, C: seq[int]): seq[int] =

  # build a graph
  var G = newSeq[seq[Edge]](N+1)
  for m in 1..M:
    G[A[m]].add(Edge(to: B[m], w: C[m]))
    G[B[m]].add(Edge(to: A[m], w: C[m]))

  proc dijkstra(a, b: int): int =
    var dist = newSeqWith(N+1, int.high div 4)
    dist[a] = 0

    type HeapItem = tuple[d: int; v: int]
    var q = initHeapQueue[HeapItem]()
    q.push((d: dist[a], v: a))

    while q.len > 0:
      # d: vに対するキー値（これでsort）
      # v: 使用済みでない頂点のうちd[v]が最小の頂点
      let qtop = q.pop()
      var (d, v) = (qtop.d, qtop.v)

      # d > dist[v]は、(d, v)がゴミであることを意味する
      if d > dist[v]: continue

      # 頂点vを始点とした各辺の緩和
      for e in G[v]:
        if dist[e.to] > dist[v] + e.w:
          dist[e.to] = dist[v] + e.w
          q.push((d: dist[e.to], v: e.to))

    return dist[b]

  var maxTime = 0
  for k in 1..N:
    var tm = dijkstra(1, k) + dijkstra(k, N)
    result.add tm


#---------------------------------------------------
proc shift(S: var seq[string]): string =
  result = S[0]
  S.delete(0)

proc runTestCase(testcase: string) =
  var
    N, M: int
    A, B, C: seq[int]
    res, output: seq[int]

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

  (N, M) = lines.shift.splitWhitespace.map(parseInt)
  A.setLen(M+1)
  B.setLen(M+1)
  C.setLen(M+1)

  for i in 1..M:
    var ln = lines.shift.splitWhitespace.map(parseInt)
    (A[i], B[i], C[i]) = ln

  # 実行

  res = solve(N, M, A, B, C)

  # 出力例を読む

  while lines[0].strip == "": lines.delete(0)
  hd = lines.shift.splitWhitespace
  if hd[1] != "出力例":
    raiseAssert("出力例が見当たらない")

  output = lines.map(parseInt)

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
  var f = readFile("sample/013.txt")
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
