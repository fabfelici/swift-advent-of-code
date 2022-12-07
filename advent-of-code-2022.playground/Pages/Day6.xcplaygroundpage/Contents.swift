extension String {
  func firstIndex(whereDistinct size: Int) -> Int? {
    var set = Set([Character]())
    let array = Array(self)
    for (offset, char) in array.enumerated() {
      if set.contains(char) {
        set.removeAll()
        var i = offset - 1
        while array[i] != char {
          set.insert(array[i])
          i -= 1
        }
      }
      set.insert(char)
      if set.count == size {
        return offset + 1
      }
    }
    return nil
  }
}

let input = "day6".load()!.trimmingCharacters(in: .newlines)
input.firstIndex(whereDistinct: 4)
input.firstIndex(whereDistinct: 14)
