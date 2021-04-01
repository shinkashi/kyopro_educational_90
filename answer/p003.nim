import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

const MAX = int.high div 10

## 1. Get diameter by doing dfs twice

proc solve(N: int; A, B: seq[int]): int =

  proc diameter(adj: Table[int, seq[int]]; N: int): int =
    var dist = newSeqWith(N, -1)
    var farDist = 0
    var farNode: int

    proc dfs(nn: int; dd: int) =
      var stack: seq[(int, int)]
      stack.add((nn, dd))

      while stack.len > 0:
        var (n, d) = stack.pop()
        dist[n] = d
        if farDist < d:
          farDist = d
          farNode = n
        for next in adj[n]:
          if dist[next] == -1: stack.add((next, d + 1))

    dfs(0, 0)
    # dump (farDist, farNode)

    dist = newSeqWith(N, -1)
    farDist = 0
    dfs(farNode, 0)
    return farDist

  # create adj hash
  var adj: Table[int, seq[int]]
  var E = N - 1
  for e in 0..<E:
    adj.mgetOrPut(A[e]-1, @[]).add(B[e]-1)
    adj.mgetOrPut(B[e]-1, @[]).add(A[e]-1)

  return diameter(adj, N) + 1

## 2. Warshall-Floyd

proc solve2(N: int; A, B: seq[int]): int =
  proc dumpArray(d: seq[seq[int]]) =
    for line in d:
      for cell in line:
        stdout.write(if cell < MAX: $cell else: "*")
      stdout.write("\n")
    stdout.write("\n")

  # calculate distances between all nodes
  # diameter + 1 が答えなので最大のdimameterを求めれば良い

  # edges
  var E = N - 1

  # Warshall-Floyd
  # load adj list

  var d = newSeqWith(N, newSeqWith(N, MAX))
  for e in 0..<E:
    d[A[e] - 1][B[e] - 1] = 1
    d[B[e] - 1][A[e] - 1] = 1
  for n in 0..<N: d[n][n] = 0

  # dumpArray d

  for k in 0..<N:
    for i in 0..<N:
      for j in 0..<N:
        # dump (k, i, j)
        d[i][j] = min(d[i][j], d[i][k] + d[k][j])

  # dumpArray d
  return d.mapIt(it.filter(x => (x <= 10000)).max).max + 1

proc parseTestCase =
  var
    caseType: string
    caseNum: string
    N: int
    A: seq[int]
    B: seq[int]
    output: int

  var f = readFile("../sample/003.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue

    case caseType:
      of "入力例":
        doAssert scanf(lines[1], "$i", N)

        A = newSeq[int](N-1)
        B = newSeq[int](N-1)

        for n in 0..N-2:
          doAssert scanf(lines[2 + n], "$i $i", A[n], B[n])

      of "出力例":
        doAssert scanf(lines[1], "$i", output)
        styledEcho(fgYellow, &"Test Case {caseNum}:")

        var res = solve(N, A, B)

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

      else:
        raiseAssert(&"unknown caseType: {caseType}")
  echo "Finished tests"

parseTestCase()

## Large N = 10^5

proc solveBigN =
  var N = 100000
  var A = newSeq[int](N-1)
  var B = newSeq[int](N-1)
  randomize()
  echo "Really big "
  dump N
  for i in 0..<N-1:
    A[i] = i+1
    B[i] = rand(1..i+1)
  dump solve(N, A, B)

solveBigN()
