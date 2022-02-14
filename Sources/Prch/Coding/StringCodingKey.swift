import Foundation
public struct StringCodingKey: CodingKey, ExpressibleByStringLiteral {
  public let stringValue: String
  public let intValue: Int?

  public init(stringValue: String) {
    self.stringValue = stringValue
    intValue = nil
  }

  public init?(intValue: Int) {
    stringValue = String(describing: intValue)
    self.intValue = intValue
  }

  public init(stringLiteral value: String) {
    self.init(stringValue: value)
  }
}
