let input = "day1".load()?.components(separatedBy: .newlines)
  .reduce(into: [Int]()) {
    if $0.isEmpty {
      $0.append(0)
    }
    if $1.isEmpty {
      $0.append(0)
    } else {
      $0[$0.count - 1] += Int($1)!
    }
  }
  .sorted(by: >)

input![0...2]
  .reduce(0, +)
