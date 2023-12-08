import Foundation

struct Mapping {
  let instructions: String
  let maps: [String: (String, String)]

  func steps(from: String, to: Set<String>) -> Int {
    var currentNode = from
    var steps = 0
    var currentInstruction = 0
    while !to.contains(currentNode) {
      let instruction = Array(instructions)[currentInstruction]
      if instruction == "L" {
        currentNode = maps[currentNode]!.0
      } else {
        currentNode = maps[currentNode]!.1
      }
      currentInstruction += 1
      currentInstruction = currentInstruction % instructions.count
      steps += 1
    }
    return steps
  }

  func steps2() -> Int {
    var currentNodes = maps.keys.filter { $0.last == "A" }
    let zEnding = Set(maps.keys.filter { $0.last == "Z" })
    let values = currentNodes.map {
      steps(from: $0, to: zEnding)
    }
    return values.reduce(values.first!) {
      return lcm($0, $1)
    }
  }

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
}

let input = "input".lines()

func parseMap(_ input: String) -> (String, (String, String)) {
  let components = input.components(separatedBy: "=")
  let node = components[0].trimmingCharacters(in: .whitespaces)
  let cleaned = components[1]
    .replacingOccurrences(of: "(", with: "")
    .replacingOccurrences(of: ")", with: "")
    .components(separatedBy: ",")
  let left = cleaned[0].trimmingCharacters(in: .whitespaces)
  let right = cleaned[1].trimmingCharacters(in: .whitespaces)

  return (node, (left, right))
}

let parsed = Mapping(
  instructions: input[0],
  maps: Dictionary(
    input.dropFirst().map(parseMap),
    uniquingKeysWith: { $1 }
  )
)

print(parsed.steps(from: "AAA", to: Set(["ZZZ"])))
print(parsed.steps2())
