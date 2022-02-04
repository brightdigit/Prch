import Foundation

public struct StringCodingKey: CodingKey, ExpressibleByStringLiteral {
  private let string: String
  private let int: Int?

  public var stringValue: String { string }

  public init(string: String) {
    self.string = string
    int = nil
  }

  public init?(stringValue: String) {
    string = stringValue
    int = nil
  }

  public var intValue: Int? { int }
  public init?(intValue: Int) {
    string = String(describing: intValue)
    int = intValue
  }

  public init(stringLiteral value: String) {
    string = value
    int = nil
  }
}
