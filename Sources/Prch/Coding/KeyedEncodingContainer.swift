import Foundation

// any encoding
public extension KeyedEncodingContainer {
  mutating func encodeAnyIfPresent<T>(_ value: T?, forKey key: K) throws {
    guard let value = value else { return }
    try encodeIfPresent(AnyCodable(value), forKey: key)
  }

  mutating func encodeAny<T>(_ value: T, forKey key: K) throws {
    try encode(AnyCodable(value), forKey: key)
  }
}
