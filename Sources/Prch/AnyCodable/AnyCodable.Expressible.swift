import Foundation

extension AnyCodable: ExpressibleByNilLiteral,
  ExpressibleByBooleanLiteral,
  ExpressibleByIntegerLiteral,
  ExpressibleByFloatLiteral,
  ExpressibleByStringLiteral,
  ExpressibleByArrayLiteral,
  ExpressibleByDictionaryLiteral {
  public init(nilLiteral _: ()) {
    self.init(nil as Any?)
  }

  public init(booleanLiteral value: Bool) {
    self.init(value)
  }

  public init(integerLiteral value: Int) {
    self.init(value)
  }

  public init(floatLiteral value: Double) {
    self.init(value)
  }

  public init(extendedGraphemeClusterLiteral value: String) {
    self.init(value)
  }

  public init(stringLiteral value: String) {
    self.init(value)
  }

  public init(arrayLiteral elements: Any...) {
    self.init(elements)
  }

  public init(dictionaryLiteral elements: (AnyHashable, Any)...) {
    self.init([AnyHashable: Any](elements, uniquingKeysWith: { first, _ in first }))
  }
}
