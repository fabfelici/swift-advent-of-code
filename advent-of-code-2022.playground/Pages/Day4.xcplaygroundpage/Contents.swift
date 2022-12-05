func solve1(left: ClosedRange<Int>, right: ClosedRange<Int>) -> Bool {
  Set(left).isSubset(of: right) || Set(left).isSuperset(of: right)
}

func solve2(left: ClosedRange<Int>, right: ClosedRange<Int>) -> Bool {
  left.overlaps(right)
}

let input = "day4".load()?.components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

let parsed = input?.map {
  $0.components(separatedBy: ",")
    .map {
      $0.components(separatedBy: "-")
        .compactMap(Int.init)
    }
    .map { $0[0]...$0[1] }
}
.map { ($0[0], $0[1]) }

[solve1, solve2].compactMap { fun in
  parsed?.filter { fun($0, $1) }.count
}
