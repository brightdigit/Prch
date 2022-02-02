import Foundation

public extension Date {
  func encode(with dateEncodingFormatter: DateFormatter) -> Any {
    dateEncodingFormatter.string(from: self)
  }
}

public extension Optional where Wrapped == Date {
  func encode(with dateEncodingFormatter: DateFormatter) -> Any? {
    self?.encode(with: dateEncodingFormatter)
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
