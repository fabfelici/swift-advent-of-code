class Node: Hashable {

  func hash(into hasher: inout Hasher) {
    name.hash(into: &hasher)
  }

  static func == (lhs: Node, rhs: Node) -> Bool {
    lhs.name == rhs.name
  }

  let name: String
  var parent: Node?
  var children = Set<Node>()
  let isDir: Bool
  let fileSize: Int?

  var size: Int {
    if isDir {
      return children.reduce(0) {
        $0 + ($1.fileSize ?? $1.size)
      }
    } else {
      return fileSize!
    }
  }

  init(
    name: String,
    isDir: Bool,
    fileSize: Int?
  ) {
    self.name = name
    self.isDir = isDir
    self.fileSize = fileSize
  }
}

enum Command {
  case ls
  case cd(String)
}

enum Entry {
  case dir(name: String)
  case file(name: String, size: Int)
}

enum TerminalOutput {
  case command(Command)
  case output(Entry)

  init(_ string: String) {
    let components = string.components(separatedBy: .whitespaces)
    if components[0] == "$" {
      switch components[1] {
      case "cd":
        self = .command(.cd(components[2]))
      case "ls":
        self = .command(.ls)
      default:
        fatalError()
      }
    } else {
      switch components[0] {
      case "dir":
        self = .output(.dir(name: components[1]))
      default:
        self = .output(.file(name: components[1], size: Int(components[0])!))
      }
    }
  }
}

func parse(_ input: [TerminalOutput]) -> Node {
  var current: Node!
  for entry in input {
    switch entry {
    case let .command(command):
      switch command {
      case .ls:
        break
      case let .cd(dir):
        switch dir {
        case "/":
          current = .init(name: dir, isDir: true, fileSize: nil)
        case "..":
          current = current.parent
        default:
          let first = current.children.first { $0.name == dir }!
          current = first
        }
      }
    case let .output(entry):
      switch entry {
      case let .file(fileName, size):
        current.children.insert(.init(name: fileName, isDir: false, fileSize: size))
      case let .dir(dirName):
        let node = Node(name: dirName, isDir: true, fileSize: nil)
        current.children.insert(node)
        node.parent = current
      }
    }
  }

  while current.parent != nil {
    current = current.parent
  }

  return current
}

func solve1(_ root: Node) -> Int {
  var res = 0

  func dfs(_ node: Node) {
    let size = node.size
    if size <= 100000 {
      res += size
    }
    for child in node.children.filter(\.isDir) {
      dfs(child)
    }
  }

  dfs(root)
  return res
}

func solve2(_ root: Node) -> Int {
  var candidates = [Int]()
  let available = 70000000 - root.size
  let target = 30000000

  func dfs(_ node: Node) {
    let size = node.size
    if available + size >= target {
      candidates.append(size)
    }
    for child in node.children.filter(\.isDir) {
      dfs(child)
    }
  }

  dfs(root)
  return candidates.min()!
}

let input = "day7".load()!.trimmingCharacters(in: .newlines)
  .components(separatedBy: .newlines)
  .map(TerminalOutput.init)

let node = parse(input)
solve1(node)
solve2(node)
