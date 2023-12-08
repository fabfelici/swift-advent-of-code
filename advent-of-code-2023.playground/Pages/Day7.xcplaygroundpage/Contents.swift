enum Card: String {
  case two = "2"
  case three = "3"
  case four = "4"
  case five = "5"
  case six = "6"
  case seven = "7"
  case eight = "8"
  case nine = "9"
  case ten = "T"
  case jack = "J"
  case queen = "Q"
  case king = "K"
  case ace = "A"
}

struct Hand: Comparable {

  enum Kind: Int, Comparable {
    case high
    case onePair
    case twoPair
    case three
    case full
    case poker
    case fivePoker

    static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.rawValue < rhs.rawValue
    }
  }

  let cards: [Card]
  let bid: Int
  let type: Hand.Kind
  let cardValues: [Int]

  init(
    cards: [Card],
    bid: Int,
    handStrategy: HandStrategy
  ) {
    self.cards = cards
    self.bid = bid
    self.type = handStrategy.kind(cards: cards)
    self.cardValues = cards.map(handStrategy.value)
  }

  static func < (lhs: Hand, rhs: Hand) -> Bool {
    guard lhs.type == rhs.type else { return lhs.type < rhs.type }
    for (left, right) in zip(lhs.cardValues, rhs.cardValues) {
      if left == right { continue }
      return left < right
    }
    return false
  }

  static func == (lhs: Hand, rhs: Hand) -> Bool {
    lhs.cards == rhs.cards
  }
}

protocol HandStrategy {
  func kind(cards: [Card]) -> Hand.Kind
  func value(card: Card) -> Int
}

struct DefaultHandStrategy: HandStrategy {
  func kind(cards: [Card]) -> Hand.Kind {
    let counts = cards.reduce(into: [Card: Int]()) {
      $0[$1, default: 0] += 1
    }
    switch counts.count {
    case 1:
      return .fivePoker

    case 2:
      if counts.values.contains(4) {
        return .poker
      } else if counts.values.contains(3) {
        return .full
      }

    case 3:
      return counts.values.contains(3) ? .three : .twoPair

    case 4:
      return .onePair

    case 5:
      return .high

    default:
      fatalError()
    }
    fatalError()
  }

  func value(card: Card) -> Int {
    switch card {
    case .two: 2
    case .three: 3
    case .four: 4
    case .five: 5
    case .six: 6
    case .seven: 7
    case .eight: 8
    case .nine: 9
    case .ten: 10
    case .jack: 11
    case .queen: 12
    case .king: 13
    case .ace: 14
    }
  }
}

struct JackAsJokerHandStrategy: HandStrategy {

  private let defaultStrategy: HandStrategy

  init(defaultStrategy: HandStrategy) {
    self.defaultStrategy = defaultStrategy
  }

  func kind(cards: [Card]) -> Hand.Kind {
    let counts = cards.reduce(into: [Card: Int]()) {
      $0[$1, default: 0] += 1
    }
    let jackCounts = cards.filter { $0 == .jack }.count
    switch counts.count {
    case 2:
      if jackCounts > 0 {
        return .fivePoker
      }

    case 3:
      if jackCounts == 1 {
        if counts.values.contains(3) {
          return .poker
        } else if counts.values.contains(2) {
          return .full
        }
      } else if jackCounts == 2 {
        return .poker
      }

    case 4:
      if jackCounts > 0 {
        return .three
      }

    case 5:
      if jackCounts > 0 {
        return .onePair
      }

    default:
      return defaultStrategy.kind(cards: cards)
    }

    return defaultStrategy.kind(cards: cards)
  }

  func value(card: Card) -> Int {
    switch card {
    case .jack: 1
    default:
      defaultStrategy.value(card: card)
    }
  }
}

func solve(_ input: [Hand]) -> Int {
  input.sorted().enumerated().reduce(0) {
    $0 + ($1.offset + 1) * $1.element.bid
  }
}

let defaultStrategy = DefaultHandStrategy()
let jackAsJokerStrategy = JackAsJokerHandStrategy(defaultStrategy: defaultStrategy)

let input = "input".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

let parsed = input.map {
  let components = $0.components(separatedBy: .whitespaces)
  return Hand(
    cards: components[0]
      .map(String.init)
      .compactMap(Card.init),
    bid: Int(components[1])!,
    handStrategy: jackAsJokerStrategy // defaultStrategy
  )
}

solve(parsed)
