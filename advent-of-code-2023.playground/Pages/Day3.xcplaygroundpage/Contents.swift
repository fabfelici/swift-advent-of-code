import Foundation

let input = "input".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }
  .map(Array.init)
  .map { $0.map(String.init) }

let symbols = CharacterSet.symbols
let punctuations = CharacterSet.punctuationCharacters
let allSymbols = symbols.union(punctuations)
var allExceptPeriods = allSymbols
allExceptPeriods.remove(".")

let offsets = [
  (-1, -1),
  (0, -1),
  (1, -1),
  (1, 0),
  (1, 1),
  (0, 1),
  (-1, 1),
  (-1, 0)
]

func solve1(_ input: [[String]]) -> Int {
  var mutable = input
  var res = 0
  for y in 0..<input.count {
    for x in 0..<input[y].count {
      if input[y][x].rangeOfCharacter(from: allExceptPeriods) != nil {
        res += offsets
          .map { (x + $0, y + $1) }
          .reduce(0) {
            $0 + (visitNumberFrom(&mutable, at: $1) ?? 0)
          }
      }
    }
  }
  return res
}

func visitNumberFrom(_ matrix: inout [[String]], at position: (Int, Int)) -> Int? {
  guard position.1 >= 0, position.1 < matrix.count else { return nil }
  let row = matrix[position.1]
  guard position.0 >= 0, position.0 < row.count else { return nil }
  var value = row[position.0]
  guard value.rangeOfCharacter(from: allSymbols) == nil else { return nil }
  matrix[position.1][position.0] = "."
  var currentPosition = position.0 - 1
  while currentPosition >= 0, row[currentPosition].rangeOfCharacter(from: allSymbols) == nil {
    value = "\(row[currentPosition])" + value
    matrix[position.1][currentPosition] = "."
    currentPosition -= 1
  }
  currentPosition = position.0 + 1
  while currentPosition < row.count, row[currentPosition].rangeOfCharacter(from: allSymbols) == nil {
    value += "\(row[currentPosition])"
    matrix[position.1][currentPosition] = "."
    currentPosition += 1
  }
  return Int(value)!
}

func solve2(_ input: [[String]]) -> Int {
  var mutable = input
  var res = 0
  for y in 0..<input.count {
    for x in 0..<input[y].count {
      if input[y][x] == "*" {
        let numbers = offsets
          .map { (x + $0, y + $1) }
          .compactMap {
            visitNumberFrom(&mutable, at: $0)
          }

        if numbers.count == 2 {
          res += numbers.reduce(1, *)
        }
      }
    }
  }
  return res
}

solve1(input)
solve2(input)
