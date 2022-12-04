import Foundation

func memoize<T: Hashable, U>(_ work: @escaping (T) -> U) -> (T) -> U {
  var memo = [T: U]()

  func wrap(x: T) -> U {
    if let q = memo[x] { return q }
    let r = work(x)
    memo[x] = r
    return r
  }
  return wrap
}

let isSmallCave: (String) -> Bool = memoize { $0.allSatisfy(\.isLowercase) }

let input = "day12".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }
  .map {
    $0.components(separatedBy: "-")
  }

func parse(input: [[String]]) -> [String: [String]] {
  return input.reduce(into: [:]) {
    $0[$1[0], default: []].append($1[1])
    $0[$1[1], default: []].append($1[0])
  }
}

func solve1(input: [String: [String]]) -> Int {
  var visited = Set<String>()
  var paths = [[String]]()
  var path = [String]()
  visit(from: "start", to: "end", input: input, visited: &visited, paths: &paths, path: &path)
  return paths.count
}

func visit(from: String, to: String, input: [String: [String]], visited: inout Set<String>, paths: inout [[String]], path: inout [String]) {
  if isSmallCave(from) {
    visited.insert(from)
  }
  path.append(from)
  if from == to {
    paths.append(path)
  } else {
    let children = input[from]!
    for child in children {
      if !visited.contains(child) {
        visit(from: child, to: to, input: input, visited: &visited, paths: &paths, path: &path)
      }
    }
  }
  path.popLast()
  visited.remove(from)
}

solve1(input: parse(input: input))

func solve2(input: [String: [String]]) -> Int {
  var visited = [String: Int]()
  var paths = [[String]]()
  var path = [String]()
  visit2(from: "start", to: "end", input: input, visited: &visited, paths: &paths, path: &path)
  return paths.count
}

func visit2(
  from: String,
  to: String,
  input: [String: [String]],
  visited: inout [String: Int],
  paths: inout [[String]],
  path: inout [String]
) {
  if isSmallCave(from) {
    visited[from, default: 0] += 1
  }
  path.append(from)
  if from == to {
    paths.append(path)
  } else {
    let children = input[from]!
    for child in children {
      if visited[child, default: 0] < 1 {
        visit2(from: child, to: to, input: input, visited: &visited, paths: &paths, path: &path)
      } else if !visited.contains(where: { $1 == 2 }) && child != "start" {
        visit2(from: child, to: to, input: input, visited: &visited, paths: &paths, path: &path)
      }
    }
  }
  path.popLast()
  visited[from, default: 0] -= 1
}

solve2(input: parse(input: input))
