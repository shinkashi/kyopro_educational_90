import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm,
    math, terminal

# Split the yokan into max pieces that are all M or bigger
proc canSplit(piece: seq[int], M: int): int =
  var i = 0
  var total = 0
  var cnt = 0
  while i < piece.len:
    total += piece[i]
    if total >= M:
      total = 0
      inc cnt
    inc i
  return cnt

proc solve(N, L, K: int; A: seq[int]): int =
  # prepare pieces
  var piece = newSeq[int](N + 1)
  piece[0] = A[0]
  for i in 1..<N:
    piece[i] = A[i] - A[i-1]
  piece[N] = L - A[N-1]
  # dump piece

  let x = collect(newSeq, for m in 0..(L div (K+1)): -canSplit(piece, m))
  # dump x
  return lowerBound(x, -(K+1)+1) - 1

proc parseTestCase =
  var
    caseType: string
    caseNum: int
    N: int
    L: int
    K: int
    A: seq[int]
    output: int

  let filename = "../sample/001.txt"
  echo ""
  echo &"Starting tests {filename}"

  var f = readFile(filename)
  f.add "\r\n\r\n"

  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.splitLines()

    if not (scanf(lines[0], "# $+ $i", caseType, caseNum)):
      continue

    case caseType:
      of "入力例":
        doAssert scanf(lines[1], "$i $i", N, L)
        doAssert scanf(lines[2], "$i", K)
        A = lines[3].split(" ").map(parseInt)
      of "出力例":
        doAssert scanf(lines[1], "$i", output)
        # dump N
        # dump L
        # dump K
        # dump A
        # dump output
        stdout.write &"Test Case {caseNum}: "
        var res = solve(N, L, K, A)
        if res == output:
          styledEcho(fgGreen, "PASS")
        else:
          styledEcho(fgRed, "FAIL ", fgDefault,
              &"actual {res}, expected {output}")

      else:
        raiseAssert("unknown caseType")

  echo "Finished tests"


parseTestCase()
