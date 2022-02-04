import Foundation

private let _dateEncodingFormatter = DateFormatter(
  formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ",

  locale: Locale(identifier: "en_US_POSIX"),

  calendar: Calendar(identifier: .gregorian)
)

public extension Date {
  @available(*, deprecated)
  func encode() -> Any {
    _dateEncodingFormatter.string(from: self)
  }
}

public extension JSONOptionalDate {
  func encode() -> Any? {
    date?.encode()
  }
}

public extension URL {
  func encode() -> Any {
    absoluteString
  }
}

public extension RawRepresentable {
  func encode() -> Any {
    rawValue
  }
}

public extension Array where Element: RawRepresentable {
  func encode() -> [Any] {
    map { $0.rawValue }
  }
}

public extension Dictionary where Key == String, Value: RawRepresentable {
  func encode() -> [String: Any] {
    mapValues { $0.rawValue }
  }
}

public extension UUID {
  func encode() -> Any {
    uuidString
  }
}

extension String {
  func encode() -> Any {
    self
  }
}

extension Data {
  func encode() -> Any {
    self
  }
}
