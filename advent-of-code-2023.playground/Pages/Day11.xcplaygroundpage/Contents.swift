import simd

let input = "input".lines().map(Array.init)

func solve(_ input: [[Character]], galaxyWidth: Int) -> Int {
  var res = 0
  var galaxies = [SIMD2<Int>]()
  let emptyCols = emptyColumns(input)
  let emptyRows = emptyRows(input)
  for row in 0..<input.count {
    for col in 0..<input[row].count {
      if input[row][col] == "#" {
        let newGalaxy = SIMD2(x: col, y: row)
        res += galaxies.reduce(0) { acc, galaxy in
          let yDistance = abs(newGalaxy.y - galaxy.y)
          let xDistance = abs(newGalaxy.x - galaxy.x)
          let horizontalEmpty = emptyRows.filter {
            $0 > galaxy.y && $0 < newGalaxy.y
          }
          let verticalEmpty = emptyCols.filter {
            if galaxy.x > newGalaxy.x {
              return $0 > newGalaxy.x && $0 < galaxy.x
            } else {
              return $0 > galaxy.x && $0 < newGalaxy.x
            }
          }
          return acc
            + xDistance
            + yDistance
            + horizontalEmpty.count * galaxyWidth
            + verticalEmpty.count * galaxyWidth
            - horizontalEmpty.count
            - verticalEmpty.count
        }
        galaxies.append(newGalaxy)
      }
    }
  }
  return res
}

func emptyColumns(_ input: [[Character]]) -> [Int] {
  (0..<input[0].count).compactMap { col in
    let isEmpty = (0..<input.count)
      .map { input[$0][col] }
      .allSatisfy { $0 == "." }
    return isEmpty ? col : nil
  }
}

func emptyRows(_ input: [[Character]]) -> [Int] {
  (0..<input.count).compactMap { row in
    let isEmpty = (0..<input[row].count)
      .map { input[row][$0] }
      .allSatisfy { $0 == "." }
    return isEmpty ? row : nil
  }
}

solve(input, galaxyWidth: 2)
solve(input, galaxyWidth: 1_000_000)
