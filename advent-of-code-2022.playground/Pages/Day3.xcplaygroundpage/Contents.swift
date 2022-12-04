let chars = ["a", "A"]
  .map { Int(($0 as UnicodeScalar).value) }
  .reduce(into: [Character: Int]()) {
    for i in 0 ..< 26 {
      $0[Character(UnicodeScalar(i + $1)!)] = $1 == 65 ? 26 + i + 1 : i + 1
    }
  }

func solveLine(_ line: String) -> Int {
  let array = Array(line)
  let mid = Int(array.count / 2)
  let intersection = Set(array[..<mid]).intersection(array[mid...])
  return chars[intersection.first!]!
}

func solveChunk(_ input: [String]) -> Int {
  let intersection = Set(input[0]).intersection(input[1]).intersection(input[2])
  return chars[intersection.first!]!
}

let input = "day3".load()?.components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

input?
  .map(solveLine)
  .reduce(0, +)

input?
  .chunks(3)
  .map(solveChunk)
  .reduce(0, +)
