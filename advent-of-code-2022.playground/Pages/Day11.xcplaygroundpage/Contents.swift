class Monkey {
  enum Operation {
    enum Value {
      case old
      case value(Int)
    }
    case add(Int)
    case multiply(Value)
  }

  var items: [Int]
  let operation: Operation
  let divideBy: Int
  let success: Int
  let failure: Int
  var times: Int = 0

  init(
    items: [Int],
    operation: Operation,
    divideBy: Int,
    success: Int,
    failure: Int
  ) {
    self.items = items
    self.operation = operation
    self.divideBy = divideBy
    self.success = success
    self.failure = failure
  }
}

//Monkey 0:
//Starting items: 79, 98
//Operation: new = old * 19
//Test: divisible by 23
//If true: throw to monkey 2
//If false: throw to monkey 3

let input = "day11".load()!
  .components(separatedBy: "\n\n")
  .map {
    let lines = $0.components(separatedBy: .newlines)
    let items = lines[1].components(separatedBy: ": ")[1].components(separatedBy: ", ").compactMap(Int.init)
    let multiply = lines[2].components(separatedBy: "=")[1].components(separatedBy: " * ")
    let sum = lines[2].components(separatedBy: "=")[1].components(separatedBy: " + ")
    let divideBy = lines[3].components(separatedBy: .whitespaces).last!
    let success = lines[4].components(separatedBy: .whitespaces).last!
    let failure = lines[5].components(separatedBy: .whitespaces).last!
    let operation: Monkey.Operation
    if multiply.count == 2 {
      let int = Int(multiply[1])
      operation = .multiply(int.map(Monkey.Operation.Value.value) ?? .old)
    } else {
      operation = .add(Int(sum[1])!)
    }
    return Monkey(
      items: items,
      operation: operation,
      divideBy: Int(divideBy)!,
      success: Int(success)!,
      failure: Int(failure)!
    )
  }

func solve(
  monkeys: [Monkey],
  rounds: Int
) -> Int {
  var monkeys = monkeys
  for _ in 0...rounds - 1 {
    for monkey in monkeys {
      while !monkey.items.isEmpty {
        let item = monkey.items.removeFirst()
        monkey.times += 1
        var worry: Int
        switch monkey.operation {
        case .add(let value):
          worry = item + value
        case .multiply(let value):
          switch value {
          case .value(let x):
            worry = item * x
          case .old:
            worry = item * item
          }
        }
        worry = worry / 3
        let chosenMonkey: Monkey
        if worry.isMultiple(of: monkey.divideBy) {
          chosenMonkey = monkeys[monkey.success]
        } else {
          chosenMonkey = monkeys[monkey.failure]
        }
        chosenMonkey.items.append(worry)
      }
    }
    print(monkeys.map(\.items))
  }
  return monkeys.map(\.times).sorted(by: >)[...1].reduce(1, *)
}

//solve(monkeys: input, rounds: 20)

func solve2(
  monkeys: [Monkey],
  rounds: Int
) -> Int {
  var monkeys = monkeys
  for _ in 0...rounds - 1 {
    for monkey in monkeys {
      while !monkey.items.isEmpty {
        let item = monkey.items.removeFirst()
        monkey.times += 1
        var worry: Int
        switch monkey.operation {
        case .add(let value):
          worry = item + value
        case .multiply(let value):
          switch value {
          case .value(let x):
            worry = item * x
          case .old:
            worry = item * item
          }
        }
        let chosenMonkey: Monkey
        let lcmAll = monkeys.map(\.divideBy).reduce(1, lcm)
        worry = worry % lcmAll
        if worry.isMultiple(of: monkey.divideBy) {
          chosenMonkey = monkeys[monkey.success]
        } else {
          chosenMonkey = monkeys[monkey.failure]
        }
        chosenMonkey.items.append(worry)
      }
    }
  }
  return monkeys.map(\.times).sorted(by: >)[...1].reduce(1, *)
}

//solve2(monkeys: input, rounds: 10000)

func gcd(_ x: Int, _ y: Int) -> Int {
  var a = 0
  var b = max(x, y)
  var r = min(x, y)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}

func lcm(_ x: Int, _ y: Int) -> Int {
  return x / gcd(x, y) * y
}
