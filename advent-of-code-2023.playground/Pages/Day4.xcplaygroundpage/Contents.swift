import Foundation

let input = "input".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }
  .map { $0.components(separatedBy: "|") }
  .map {
    [
      $0[0].components(separatedBy: ":")[1],
      $0[1]
    ]
    .map {
      $0.trimmingCharacters(in: .whitespaces)
        .components(separatedBy: .whitespaces)
        .compactMap(Int.init)
    }
    .map(Set.init)
  }

func solve1(_ input: [[Set<Int>]]) -> Int {
  input
    .map { $0[0].intersection($0[1]).count }
    .filter { $0 > 0 }
    .reduce(0) {
      $0 + NSDecimalNumber(decimal: pow(2, $1 - 1)).intValue
    }
}

solve1(input)

func solve2(_ input: [[Set<Int>]]) -> Int {
  var count = Array(repeating: 1, count: input.count)
  input
    .enumerated()
    .map { index, element in
      (index, element[0].intersection(element[1]).count)
    }
    .filter { $1 > 0 }
    .forEach { index, element in
      (1...element)
        .forEach { offset in
          count[index + offset] += count[index]
        }
    }
  return count.reduce(0, +)
}

solve2(input)
