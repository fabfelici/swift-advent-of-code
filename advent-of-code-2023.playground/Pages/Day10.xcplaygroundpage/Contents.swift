import UIKit

enum Tile: String {

  case empty = "."
  case vertical = "|"
  case horizontal = "-"
  case northEast = "L"
  case northWest = "J"
  case southWest = "7"
  case southEast = "F"
  case start = "S"
  
  enum Side {
    case top
    case right
    case bottom
    case left

    var offset: CGPoint {
      switch self {
      case .top:
        .init(x: 0, y: -1)
      case .right:
        .init(x: 1, y: 0)
      case .bottom:
        .init(x: 0, y: 1)
      case .left:
        .init(x: -1, y: 0)
      }
    }

    var connectable: [Tile] {
      switch self {
      case .top:
        [.vertical, .southEast, .southWest]
      case .right:
        [.horizontal, .northWest, .southWest]
      case .bottom:
        [.vertical, .northEast, .northWest]
      case .left:
        [.horizontal, .southEast, .northEast]
      }
    }
  }

  var connectableSides: [Side] {
    switch self {
    case .empty:
      []
    case .vertical:
      [.top, .bottom]
    case .horizontal:
      [.right, .left]
    case .northEast:
      [.top, .right]
    case .northWest:
      [.top, .left]
    case .southWest:
      [.bottom, .left]
    case .southEast:
      [.bottom, .right]
    case .start:
      [.top, .bottom, .right, .left]
    }
  }
}

let input = "input".lines()
  .map {
    $0.map(String.init)
      .compactMap(Tile.init)
  }

extension Array<[Tile]> {
  subscript(_ point: CGPoint) -> Tile {
    self[Int(point.y)][Int(point.x)]
  }
}

extension CGPoint: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

func solve(_ input: [[Tile]]) {
  var visited = Set<CGPoint>()
  let path = UIBezierPath()
  let rect = CGRect(x: 0, y: 0, width: input[0].count, height: input.count)

  func dfs(_ from: CGPoint) {
    visited.insert(from)
    path.addLine(to: from)
    let next = input[from].connectableSides.compactMap {
      let nextPosition = CGPoint(x: from.x + $0.offset.x, y: from.y + $0.offset.y)
      if rect.contains(nextPosition), !visited.contains(nextPosition) {
        if $0.connectable.contains(input[nextPosition]) {
          return nextPosition
        }
      }
      return nil
    }.first
    guard let next = next else { return }
    dfs(next)
  }

  var x = 0
  var y = 0
  for row in 0..<input.count {
    for col in 0..<input[row].count {
      if input[row][col] == .start {
        x = col
        y = row
      }
    }
  }
  let start = CGPoint(x: x, y: y)
  path.move(to: start)
  dfs(start)
  path.close()
  print(visited.count / 2)
  var count = 0
  for row in 0..<input.count {
    for col in 0..<input[row].count {
      if path.contains(.init(x: col, y: row)) {
        count += 1
      }
    }
  }
  print(count - visited.count)
}

solve(input)
