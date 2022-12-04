import Foundation

public extension String {
  func load() -> String? {
    return try? Bundle.main.url(forResource: self, withExtension: "txt")
      .flatMap(String.init(contentsOf:))
  }
}

struct Point: Hashable, CustomDebugStringConvertible {
  let x: Int
  let y: Int

  var debugDescription: String {
    return "\(x) - \(y)"
  }
}

func solve1(input: [[Int]]) -> Int {
  var paths = [[Point]]()
  var path = [Point]()
  visit(
    from: .init(x: 0, y: 0),
    to: .init(x: input[input.count - 1].count - 1, y: input.count - 1),
    input: input,
    paths: &paths,
    path: &path)
  return paths.map {
    $0.map {
      input[$0.y][$0.x]
    }
    .reduce(0, +)
  }
  .min()! - input[0][0]
}

func visit(from: Point, to: Point, input: [[Int]], paths: inout [[Point]], path: inout [Point]) {
  path.append(from)
  if from == to {
    paths.append(path)
  } else {
    let children = [Point(x: from.x + 1, y: from.y), Point(x: from.x, y: from.y + 1)].filter {
      $0.y < input.count && $0.x < input[$0.y].count
    }
    print(children)
    for child in children {
      visit(from: child, to: to, input: input, paths: &paths, path: &path)
    }
  }
  path.popLast()
}

func parse(input: String) -> [[Int]] {
  return input.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .map {
      Array($0).map(String.init).compactMap(Int.init)
    }
}

let input = parse(input: "test".load()!)

print(solve1(input: input))
