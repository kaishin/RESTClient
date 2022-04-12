import Foundation

public struct URIPath {
  public var fragments: [CustomStringConvertible]
}

extension URIPath {
  public init(_ fragments: [String] = []) {
    self.fragments = fragments
  }

  public init(_ string: String) {
    self.fragments = string.components(separatedBy: "/")
  }

  public init(stringLiteral value: String) {
    self.fragments = value.components(separatedBy: "/")
  }

  public var fullPath: String {
    fragments.map(\.description).joined(separator: "/")
  }
}
