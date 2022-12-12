let input = "day8".load()!
  .trimmingCharacters(in: .whitespacesAndNewlines)
  .components(separatedBy: .newlines)
  .map(Array.init)
  .map { $0.map(String.init).compactMap(Int.init) }

func solve1(_ input: [[Int]]) -> Int {
  func visible(_ row: Int, _ col: Int) -> Bool {
    let current = input[row][col]
    let left = input[row][..<col]
    let right = input[row][(col + 1)...]
    let topRows = input[..<row]
    let top = topRows.map {
      $0[col]
    }
    let bottomRows = input[(row + 1)...]
    let bottom = bottomRows.map {
      $0[col]
    }
    return !left.contains { $0 > current } ||
      !right.contains { $0 > current } ||
      !top.contains { $0 > current } ||
      !bottom.contains { $0 > current }
  }

  var res = 0
  for i in 0..<input.count {
    for j in 0..<input.count {
      if i == 0 || i == input.count - 1 || j == 0 || j == input.count - 1 {
        res += 1
      } else {
        res += visible(i, j) ? 1 : 0
      }
    }
  }
  return res
}

func solve2(_ input: [[Int]]) -> Int {
  func score(_ row: Int, _ col: Int) -> Int {
    let current = input[row][col]
    let left = input[row][..<col]
    let right = input[row][(col + 1)...]
    let topRows = input[..<row]
    let top = topRows.map {
      $0[col]
    }
    let bottomRows = input[(row + 1)...]
    let bottom = bottomRows.map {
      $0[col]
    }
    return [
      left.reversed(),
      Array(right),
      top.reversed(),
      Array(bottom)
    ]
    .map {
      var count = 0
      for elem in $0 {
        if elem < current {
          count += 1
        } else if elem >= current {
          count += 1
          break
        }
      }
      return count
    }
    .reduce(1, *)
  }

  var res = 0
  for i in 0..<input.count {
    for j in 0..<input.count {
      let score = score(i, j)
      res = max(res, score)
      print(res)
    }
  }
  return res
}

//solve1(input)
//solve2(input)
