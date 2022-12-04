import Foundation

struct Input {
  let start: String
  let mappings: [String: String]
}

func parse(input: String) -> Input {
  let split = input.components(separatedBy: "\n\n")
  return .init(
    start: split[0],
    mappings: parse(mappings: split[1])
  )
}

func parse(mappings: String) -> [String: String] {
  return mappings.components(separatedBy: .newlines)
    .map {
      $0.components(separatedBy: " -> ")
        .filter { !$0.isEmpty }
    }
    .filter { !$0.isEmpty }
    .reduce(into: [:]) {
      $0[$1[0]] = $1[1]
    }
}

let input = parse(input: "day14".load()!)

func solve(input: Input, times: Int) -> Int {
  var counts = [String: Int]()
  var pairCounts = [String: Int]()
  let string = Array(input.start)

  for i in 0..<string.count - 1 {
    let pair = "\(string[i])\(string[i + 1])"
    if let _ = input.mappings[pair] {
      pairCounts[pair, default: 0] += 1
    }
    counts[String(string[i]), default: 0] += 1
  }
  counts[String(string.last!), default: 0] += 1

  for _ in (0..<times) {
    var newPairsCount = [String: Int]()
    for pair in pairCounts {
      let array = Array(pair.key)
      if let match = input.mappings[pair.key] {
        counts[match, default: 0] += pair.value
        newPairsCount["\(array[0])\(match)", default: 0] += pair.value
        newPairsCount["\(match)\(array[1])", default: 0] += pair.value
      }
      pairCounts = newPairsCount
    }
  }
  let max = counts.max { $0.value < $1.value }!.value
  let min = counts.min { $0.value < $1.value }!.value

  return max - min
}

print(solve(input: input, times: 40))
