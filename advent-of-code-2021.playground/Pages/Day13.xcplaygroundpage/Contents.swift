import Foundation

enum Fold {
  case x(Int)
  case y(Int)
}

struct Point: Hashable {
  let x: Int
  let y: Int
}

struct Input {
  let coords: Set<Point>
  let folds: [Fold]
}

func parse(input: String) -> Input {
  let split = input.components(separatedBy: "\n\n")
  return .init(
    coords: Set(parse(coords: split[0])),
    folds: parse(folds: split[1])
  )
}

func parse(coords: String) -> [Point] {
  return coords.components(separatedBy: .newlines)
    .map {
      let split = $0.components(separatedBy: .punctuationCharacters)
      return .init(x: Int(split[0])!, y: Int(split[1])!)
    }
}

func parse(folds: String) -> [Fold] {
  return folds.components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
    .compactMap {
      let split = $0.components(separatedBy: "=")
      let coord = split[0].components(separatedBy: .whitespaces).last!
      switch coord {
      case "x":
        return .x(Int(split[1])!)
      case "y":
        return .y(Int(split[1])!)
      default:
        return nil
      }
    }
}

let input = parse(input: "day13".load()!)

func solve1(input: Input) -> Int {
  let cols = input.coords.max {
    $0.x < $1.x
  }!.x
  let rows = input.coords.max {
    $0.y < $1.y
  }!.y

  var grid = (0...rows).map { y in
    (0...cols).map { x in
      input.coords.contains(Point(x: x, y: y))
    }
  }

  let fold = input.folds.first!
  print(fold)
  switch fold {
  case let .x(value):
    let leftFold: [[Bool]] = grid.map {
      return Array($0[..<value].reversed())
    }

    let rightFold: [[Bool]] = grid.map {
      return Array($0[(value + 1)...])
    }

    grid = rightFold.enumerated().map { row in
      row.element.enumerated().map { column in
        return column.element || leftFold[row.offset][column.offset]
      }
    }
  case let .y(value):
    let upperFold = grid[..<value]
    let bottomFold = Array(grid[(value + 1)...].reversed())
    grid = upperFold.enumerated().map { row in
      row.element.enumerated().map { column in
        return column.element || bottomFold[row.offset][column.offset]
      }
    }
  }

  return grid.reduce(0) {
    $0 + $1.reduce(0) {
      $0 + ($1 ? 1 : 0)
    }
  }
}

func solve2(input: Input) -> Int {
  let cols = input.coords.max {
    $0.x < $1.x
  }!.x
  let rows = input.coords.max {
    $0.y < $1.y
  }!.y

  var grid = (0...rows).map { y in
    (0...cols).map { x in
      input.coords.contains(Point(x: x, y: y))
    }
  }

  for fold in input.folds {
    switch fold {
    case let .x(value):
      let leftFold: [[Bool]] = grid.map {
        return Array($0[..<value].reversed())
      }

      let rightFold: [[Bool]] = grid.map {
        return Array($0[(value + 1)...])
      }

      grid = rightFold.enumerated().map { row in
        row.element.enumerated().map { column in
          return column.element || leftFold[row.offset][column.offset]
        }
      }
    case let .y(value):
      let upperFold = grid[..<value]
      let bottomFold = Array(grid[(value + 1)...].reversed())
      grid = upperFold.enumerated().map { row in
        row.element.enumerated().map { column in
          return column.element || bottomFold[row.offset][column.offset]
        }
      }
    }
  }
  print(grid)
  return 0
}

solve2(input: input)
