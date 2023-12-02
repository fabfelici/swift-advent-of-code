typealias Game = [[GameItem]]

struct GameItem {
  let value: Int
  let color: Color

  var configurationKeyPath: WritableKeyPath<GameConfiguration, Int> {
    switch color {
    case .red:
      return \.red
    case .green:
      return \.green
    case .blue:
      return \.blue
    }
  }
}

enum Color: String {
  case red
  case green
  case blue
}

struct GameConfiguration {
  var red: Int
  var green: Int
  var blue: Int

  var power: Int {
    red * green * blue
  }
}

let input = "input".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

let parsed = input.map {
  $0.components(separatedBy: ":")[1]
    .components(separatedBy: ";")
    .map {
      $0.components(separatedBy: ",")
        .map {
          let value = $0
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: .whitespaces)
          return GameItem(
            value: Int(value[0])!,
            color: Color(rawValue: value[1])!
          )
        }
    }
}

func solve1(_ games: [Game]) -> Int {
  let configuration = GameConfiguration(
    red: 12,
    green: 13,
    blue: 14
  )
  func isGamePossible(
    _ game: Game,
    _ configuration: GameConfiguration
  ) -> Bool {
    game.allSatisfy { group in
      group.allSatisfy { item in
        item.value <= configuration[keyPath: item.configurationKeyPath]
      }
    }
  }
  return parsed
    .enumerated()
    .filter { enumerated in
      isGamePossible(
        enumerated.element,
        configuration
      )
    }
    .map { $0.offset + 1 }
    .reduce(0, +)
}

solve1(parsed)

func solve2(_ games: [Game]) -> Int {
  func minConfiguration(
    _ game: Game
  ) -> GameConfiguration {
    game.reduce(into: .init(red: 0, green: 0, blue: 0)) { acc, group in
      group.forEach { item in
        let current = acc[keyPath: item.configurationKeyPath]
        acc[keyPath: item.configurationKeyPath] = max(current, item.value)
      }
    }
  }

  return games
    .map(minConfiguration)
    .map(\.power)
    .reduce(0, +)
}

solve2(parsed)
