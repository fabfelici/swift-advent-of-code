import Foundation

let input = "input".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

let parsed = input
  .map {
    $0.components(separatedBy: ":")[1]
      .trimmingCharacters(in: .whitespaces)
      .components(separatedBy: .whitespaces)
      .compactMap(Int.init)
  }

func solve1(_ input: [(Int, Int)]) -> Int {
  input.map(solve2).reduce(1, *)
}

solve1(Array(zip(parsed[0], parsed[1])))

let parsed2 = input
  .compactMap {
    Int(
      $0.components(separatedBy: ":")[1]
        .replacingOccurrences(of: " ", with: "")
    )
  }

func solve2(_ input: (Int, Int)) -> Int {
  let discriminant = Double(Int(pow(Double(input.0), 2)) - 4 * input.1)
  let x1 = Double(input.0 - Int(sqrt(discriminant))) / 2
  let x2 = Double(input.0 + Int(sqrt(discriminant))) / 2
  return Int(floor(x2)) - Int(ceil(x1)) + 1
}

solve2((parsed2[0], parsed2[1]))
