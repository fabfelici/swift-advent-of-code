import Foundation

public extension String {
  func load() -> String? {
    return try? Bundle.main.url(forResource: self, withExtension: "txt")
      .flatMap(String.init(contentsOf:))
  }

  func lines() -> [String] {
    load()!.components(separatedBy: .newlines)
      .filter { !$0.isEmpty }
  }
}

public extension Array {
  func chunks(_ chunkSize: Int) -> [[Element]] {
    return stride(from: 0, to: self.count, by: chunkSize).map {
      Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
    }
  }
}
