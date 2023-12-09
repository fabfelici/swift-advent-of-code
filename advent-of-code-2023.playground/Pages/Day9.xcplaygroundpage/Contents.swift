let input = "input".lines()
  .map {
    $0.components(separatedBy: .whitespaces)
      .compactMap(Int.init)
  }

func solve(_ input: [[Int]], partTwo: Bool) -> Int {
  func rec(_ input: [Int]) -> Int {
    if input.allSatisfy({ $0 == 0 }) { return 0 }
    let newArray = (1..<input.count)
      .map {
        input[$0] - input[$0 - 1]
      }
    return partTwo ?
      (input.first! - rec(newArray)) :
      (input.last! + rec(newArray))
  }
  return input.map(rec).reduce(0, +)
}

solve(input, partTwo: false)
solve(input, partTwo: true)
