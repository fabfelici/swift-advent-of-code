let input = "day1".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

func solve1(_ input: [String]) -> Int {
  input
    .reduce(0) {
      let digits = $1.compactMap { $0.wholeNumberValue }
      return $0 + (digits.first ?? 0) * 10 + (digits.last ?? 0)
    }
}

solve1(input)

let digitsMap = [
  "one": "1",
  "two": "2",
  "three": "3",
  "four": "4",
  "five": "5",
  "six": "6",
  "seven": "7",
  "eight": "8",
  "nine": "9"
]

func solve2(_ input: [String]) -> Int {
  input.compactMap { line in
    let first = findDigit(line, startIndex: 0, step: 1)
    let last = findDigit(line, startIndex: line.count - 1, step: -1)
    return Int(first + last)
  }.reduce(0, +)
}

func findDigit(_ line: String, startIndex: Int, step: Int) -> String {
  var index = startIndex
  while index >= 0, index < line.count {
    let current = String(line[line.index(line.startIndex, offsetBy: index)])
    if Int(current) != nil {
      return current
    } else {
      let substring = step == 1 ? line.prefix(index + 1) : line.suffix(line.count - index)
      for mapping in digitsMap {
        if substring.contains(mapping.key) {
          return mapping.value
        }
      }
    }
    index += step
  }
  return ""
}

solve2(input)
