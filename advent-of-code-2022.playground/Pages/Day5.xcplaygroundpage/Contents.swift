let input = "day5".load()!.components(separatedBy: "\n\n")

func parseCrane(_ input: String) -> CraneState {
  // Too lazy to parse this :P
  let components = input.components(separatedBy: .newlines).reversed()
  return .init(stacks: [])
}

func parseMoves(_ input: String) -> [Move] {
  input.components(separatedBy: .newlines).filter { !$0.isEmpty }.map(parseMove)
}

func parseMove(_ input: String) -> Move {
  let components = input.components(separatedBy: .whitespaces)
  let values = components.compactMap { Int($0) }
  return .init(quantity: values[0], from: values[1] - 1, to: values[2] - 1)
}

struct CraneState {
  var stacks: [[String]]
}

struct Move {
  let quantity: Int
  let from: Int
  let to: Int
}

func solve(moves: [Move], crane: inout CraneState) -> String {
  moves.forEach { move in
    (0..<move.quantity).forEach { _ in
      let pop = crane.stacks[move.from].popLast()!
      crane.stacks[move.to].append(pop)
    }
  }
  return crane.stacks.compactMap(\.last).joined()
}

func solve2(moves: [Move], crane: inout CraneState) -> String {
  moves.forEach { move in
    let count = crane.stacks[move.from].count
    let toBeMoved = crane.stacks[move.from][(count - move.quantity)...]
    crane.stacks[move.from].removeLast(move.quantity)
    crane.stacks[move.to].append(contentsOf: toBeMoved)
  }
  return crane.stacks.compactMap(\.last).joined()
}
var crane = CraneState(
  stacks: [
    ["N", "D", "M", "Q", "B", "P", "Z"],
    ["C", "L", "Z", "Q", "M", "D", "H", "V"],
    ["Q", "H", "R", "D", "V", "F", "Z", "G"],
    ["H", "G", "D", "F", "N"],
    ["N", "F", "Q"],
    ["D", "Q", "V", "Z", "F", "B", "T"],
    ["Q", "M", "T", "Z", "D", "V", "S", "H"],
    ["M", "G", "F", "P", "N", "Q"],
    ["B", "W", "R", "M"]
  ]
)

//let res = solve(moves: parseMoves(input[1]), crane: &crane)
let res = solve2(moves: parseMoves(input[1]), crane: &crane)
