typealias Point = SIMD2<Int>

let input = "day12".load()!
  .trimmingCharacters(in: .whitespacesAndNewlines)
  .components(separatedBy: .newlines)
  .map {
    Array($0)
  }

let directions = [Point(0, -1), Point(1, 0), Point(0, 1), Point(-1, 0)]

extension Array where Element == [Int] {
  subscript(point: Point) -> Int {
    get {
      self[point.y][point.x]
    }
    set {
      self[point.y][point.x] = newValue
    }
  }
}

func getNeighbors(
  _ heights: [[Int]],
  _ visited: Set<Point>,
  _ from: Point
) -> [Point] {
  directions
    .map { from &+ $0 }
    .filter {
      $0.x >= 0 &&
      $0.y >= 0 &&
      $0.x < heights[0].count &&
      $0.y < heights.count
    }
    .filter { !visited.contains($0) }
    .filter { heights[$0] - heights[from] <= 1 }
}

func djikstra(
  _ heights: [[Int]],
  _ from: [Point],
  _ to: Point
) -> Int {
  var queue = Set<Point>()
  var visited = Set<Point>()
  var costs = heights.map { line in
    line.map { _ in Int.max }
  }
  for point in from {
    costs[point] = 0
  }
  queue.formUnion(from)
  while !queue.isEmpty {
    let node = queue.min { costs[$0] < costs[$1] }!
    if node == to {
      return costs[to]
    }
    queue.remove(node)
    visited.insert(node)
    let neighbors = getNeighbors(heights, visited, node)
    queue.formUnion(neighbors)
    for neighbor in neighbors {
      costs[neighbor] = min(costs[neighbor], costs[node] + 1)
    }
  }
  return Int.max
}

extension Character {
  static let alphabetValue = Dictionary(uniqueKeysWithValues: zip("abcdefghijklmnopqrstuvwxyz", 1...26))
  var letterValue: Int? { Self.alphabetValue[self] }
}

extension Array where Element == [Character] {
  func indexes(of character: Character) -> [Point] {
    enumerated().flatMap { lineIndex, line in
      line.enumerated().compactMap {
        if $0.element == character {
          return Point($0.offset, lineIndex)
        }
        return nil
      }
    }
  }

  var toIntHeights: [[Int]] {
    var intCopy: [[Int]] = [[Int]](
      repeating: [Int](
        repeating: 0,
        count: self[0].count
      ),
      count: self.count
    )
    for (y, line) in self.enumerated() {
      for (x, char) in line.enumerated() {
        switch char {
        case "S":
          intCopy[y][x] = 1
        case "E":
          intCopy[y][x] = 26
        default:
          intCopy[y][x] = char.letterValue!
        }
      }
    }
    return intCopy
  }
}

func solve(_ heights: [[Character]]) -> Int {
  let start = heights.indexes(of: "S")
  let end = heights.indexes(of: "E").first!
  return djikstra(heights.toIntHeights, start, end)
}

func solve2(_ heights: [[Character]]) -> Int {
  let start = heights.indexes(of: "a") + heights.indexes(of: "S")
  let end = heights.indexes(of: "E").first!
  return djikstra(heights.toIntHeights, start, end)
}

//solve(input)
//solve2(input)
