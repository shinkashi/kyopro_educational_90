import strutils, re, strscans, sugar, parseutils, sequtils, strformat, algorithm, math
import memo, math, terminal, random, tables

type Node = tuple[ch: char, loc: int]

const INF: Node = (ch: '~', loc: -1)

type Segtree = object
  n: int
  dat: seq[Node]

proc newSegtree(origin: seq[Node]): Segtree =
  # 最下段のノード数は元配列のサイズ以上になる最小の 2 冪 -> これを n とおく
  # セグメント木全体で必要なノード数は 2n-1 個である
  var x = 1
  while origin.len > x: x *= 2
  var n = x
  var dat = newSeqWith(2 * n - 1, INF)

  # 最下段に値を入れる。途中の段はn-1個ある
  for i in 0..<origin.len: dat[i + n-1] = origin[i]

  # 下の段から最小値を埋めていく
  # 自分の子の2値を参照する
  for i in countdown(n-2, 0):
    dat[i] = min(dat[2*i+1], dat[2*i+2])

  return Segtree(n: n, dat: dat)

# 要求区間 [a, b) 中の要素の最小値を答える
# k := 自分がいるノードのインデックス
# 対象区間は [l, r) にあたる
proc query(sg: Segtree; a, b: int; k = 0, l = 0, r = -1): Node =
  var r = r

  # 最初に呼び出されたときの対象区間は [0, n)
  if r < 0: r = sg.n

  # 要求区間と対象区間が交わらない -> 適当に返す
  if r <= a or b <= l: return INF

  # 要求区間が対象区間を完全に被覆 -> 対象区間を答えの計算に使う
  if a <= l and r <= b: return sg.dat[k]

  # 要求区間が対象区間の一部を被覆 -> 子について探索を行う
  # 左側の子を vl ・ 右側の子を vr としている
  # 新しい対象区間は、現在の対象区間を半分に割ったもの
  var vl = sg.query(a, b, 2*k+1, l, (l+r) div 2);
  var vr = sg.query(a, b, 2*k+2, (l+r) div 2, r);
  return min(vl, vr);

proc solve(S: string, K: int): string =
  var origin: seq[Node]
  for i, c in S: origin.add((ch: c, loc: i))
  var sg = newSegtree(origin)

  var left = 0
  for i in 0..<K:
    var right = S.len - K + i
    var x = sg.query(left, right+1)
    result.add(x.ch)
    left = x.loc + 1

#---------------------------------------------------
proc parseTestCase =
  var
    caseType: string
    caseNum: string

  var S: string
  var K: int

  var f = readFile("sample/006.txt")
  f.add "\r\n\r\n"
  for testcase in f.findAll(re("#.+?\r\n\r\n", {reDotAll})):
    var lines = testcase.strip.splitLines()

    if not scanf(lines[0], "# $+ $+", caseType, caseNum):
      continue
    lines.delete(0, 0)

    case caseType:
      of "入力例":
        doAssert scanf(lines[0], "$+", S)
        lines.delete(0, 0)
        doAssert scanf(lines[0], "$i", K)
        lines.delete(0, 0)

      of "出力例":
        var output: string

        doAssert scanf(lines[0], "$+", output)
        lines.delete(0, 0)

        styledEcho(fgYellow, &"Test Case {caseNum}:")

        var res = solve(S, K)

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


var bigK = 10000
var bigS = ""
for i in 0..<bigK:
  bigS.add(rand('a'..'z'))

echo "*****"
echo bigS

var res = solve(bigS, bigK div 10)
echo "*****"
echo res

