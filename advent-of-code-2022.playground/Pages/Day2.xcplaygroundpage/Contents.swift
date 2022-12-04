let input = "day2".load()?.components(separatedBy: .newlines)
  .filter { !$0.isEmpty }
  .map {
    $0.components(separatedBy: .whitespaces)
      .compactMap(Move.init)
  }

enum Move: String {
  case rock
  case paper
  case scissors

  init?(rawValue: String) {
    switch rawValue {
    case "A", "X":
      self = .rock
    case "B", "Y":
      self = .paper
    case "C", "Z":
      self = .scissors
    default:
      return nil
    }
  }
}

func point(moves: [Move]) -> Int {
  let opponentMove = moves[0]
  let selfMove = moves[1]

  switch opponentMove {
  case .rock:
    switch selfMove {
    case .rock:
      return 3 + 1
    case .paper:
      return 6 + 2
    case .scissors:
      return 3
    }
  case .paper:
    switch selfMove {
    case .rock:
      return 1
    case .paper:
      return 3 + 2
    case .scissors:
      return 6 + 3
    }
  case .scissors:
    switch selfMove {
    case .rock:
      return 6 + 1
    case .paper:
      return 2
    case .scissors:
      return 3 + 3
    }
  }
}

input?.reduce(0) {
  $0 + point(moves: $1)
}

func point2(moves: [Move]) -> Int {
  let opponentMove = moves[0]
  let selfMove = moves[1]

  switch opponentMove {
  case .rock:
    switch selfMove {
    case .rock:
      return 3
    case .paper:
      return 3 + 1
    case .scissors:
      return 6 + 2
    }
  case .paper:
    switch selfMove {
    case .rock:
      return 1
    case .paper:
      return 3 + 2
    case .scissors:
      return 6 + 3
    }
  case .scissors:
    switch selfMove {
    case .rock:
      return 2
    case .paper:
      return 3 + 3
    case .scissors:
      return 6 + 1
    }
  }
}

input?.reduce(0) {
  $0 + point2(moves: $1)
}
