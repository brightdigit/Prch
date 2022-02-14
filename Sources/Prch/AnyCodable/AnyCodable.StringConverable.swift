import Foundation

extension AnyCodable: CustomStringConvertible {
  public var description: String {
    switch value {
    case is Void:
      return String(describing: nil as Any?)

    case let value as CustomStringConvertible:
      return value.description

    default:
      return String(describing: value)
    }
  }
}

extension AnyCodable: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch value {
    case let value as CustomDebugStringConvertible:
      return "AnyCodable(\(value.debugDescription))"
    default:
      return "AnyCodable(\(description))"
    }
  }
}
