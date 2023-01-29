enum Op {
  case noop
  case add(Int)
}

let input = "day10".load()!
  .trimmingCharacters(in: .whitespacesAndNewlines)
  .components(separatedBy: .newlines)
  .map {
    let components = $0.components(separatedBy: .whitespaces)
    if components.count == 2 {
      return Op.add(Int(components[1])!)
    } else {
      return Op.noop
    }
  }

func solve(ops: [Op]) -> Int {
  var cycle = 0
  var x = 1
  var values = [Int]()

  func tick() {
    cycle += 1
    if [20, 60, 100, 140, 180, 220].contains(cycle) {
      values.append(cycle * x)
    }
  }

  for op in ops {
    switch op {
    case .noop:
      tick()
    case .add(let value):
      for i in 0...1 {
        tick()
        if i == 1 {
          x += value
        }
      }
    }
  }
  return values.reduce(0, +)
}

solve(ops: input)

func solve2(ops: [Op]) -> [[String]] {
  var cycle = 0
  var sprite = 1
  var currentIndex = 0
  var crt = Array(repeating: Array(repeating: ".", count: 40), count: 6)

  func tick() {
    if cycle == sprite ||
        cycle == sprite - 1 ||
        cycle == sprite + 1 {
      crt[currentIndex][cycle] = "#"
    }
    cycle += 1
    if cycle == 40 {
      cycle = 0
      currentIndex += 1
    }
  }

  for op in ops {
    switch op {
    case .noop:
      tick()
    case .add(let value):
      for i in 0...1 {
        tick()
        if i == 1 {
          sprite += value
        }
      }
    }
  }
  return crt
}

let res = solve2(ops: input)
for line in res {
  print(line.joined())
}
