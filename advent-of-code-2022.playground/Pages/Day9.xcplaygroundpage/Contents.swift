struct Move {

  enum Kind: String {
    case left = "L"
    case right = "R"
    case up = "U"
    case down = "D"
  }

  let kind: Kind
  let amount: Int
}

let input = "day9".load()!
  .trimmingCharacters(in: .whitespacesAndNewlines)
  .components(separatedBy: .newlines)
  .map {
    let components = $0.components(separatedBy: .whitespaces)
    return Move(
      kind: .init(rawValue: components[0])!,
      amount: Int(components[1])!
    )
  }

typealias Point = SIMD2

func solve(_ moves: [Move], count: Int) -> Int {
  var nodes = Array(repeating: Point(0, 0), count: count)
  var visited = Set<String>()
  for move in moves {
    for _ in 0..<move.amount {
      for (i, node) in nodes.enumerated() {
        var newNode = node
        if i == 0 {
          switch move.kind {
          case .down:
            newNode = newNode &+ Point(0, -1)
          case .up:
            newNode = newNode &+ Point(0, 1)
          case .left:
            newNode = newNode &+ Point(-1, 0)
          case .right:
            newNode = newNode &+ Point(1, 0)
          }
        } else {
          let head = nodes[i - 1]
          let isAbove = newNode.y > head.y
          let isLeft = newNode.x < head.x
          let yDistance = abs(head.y - newNode.y)
          let xDistance = abs(head.x - newNode.x)
          if yDistance > 1 || xDistance > 1 {
            if head.x == newNode.x {
              newNode = newNode &+ Point(0, isAbove ? -1 : 1)
            } else if head.y == newNode.y {
              newNode = newNode &+ Point(isLeft ? 1 : -1, 0)
            } else {
              newNode = newNode &+ Point(isLeft ? 1 : -1, isAbove ? -1 : 1)
            }
          }
        }
        nodes[i] = newNode
        if i == count - 1 {
          visited.insert("\(nodes[i])")
        }
      }
    }
  }
  return visited.count
}
//let res1 = solve(input, count: 2)
let res2 = solve(input, count: 10)
