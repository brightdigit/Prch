import Foundation

// any decoding
public extension KeyedDecodingContainer {
  func decodeAny<T>(_: T.Type, forKey key: K) throws -> T {
    guard let value = try decode(AnyCodable.self, forKey: key).value as? T else {
      throw DecodingError.mismatch(ofType: T.self, withCodingPath: codingPath)
    }
    return value
  }

  func decodeAnyCodableDictionary(
    _ key: K) throws -> [String: AnyCodable]? {
    guard let value = try decodeIfPresent(
      AnyCodable.self, forKey: key
    )?.value else { return nil }
    if let typedValue = value as? [String: Any] {
      return typedValue.mapValues(AnyCodable.init)
    } else {
      throw DecodingError.mismatch(
        ofType: [String: AnyCodable].self,
        withCodingPath: codingPath
      )
    }
  }

  func decodeAnyIfPresent<T>(_: T.Type, forKey key: K) throws -> T? {
    try decodeOptional {
      guard let value = try decodeIfPresent(
        AnyCodable.self, forKey: key
      )?.value else { return nil }
      if let typedValue = value as? T {
        return typedValue
      } else {
        throw DecodingError.mismatch(ofType: T.self, withCodingPath: codingPath)
      }
    }
  }

  func toDictionary() throws -> [String: Any] {
    var dictionary: [String: Any] = [:]
    for key in allKeys {
      dictionary[key.stringValue] = try decodeAny(key)
    }
    return dictionary
  }

  func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
    try decode(T.self, forKey: key)
  }

  func decodeIfPresent<T>(
    _ key: KeyedDecodingContainer.Key,
    safeOptionalDecoding: Bool = false
  ) throws -> T? where T: Decodable {
    try decodeOptional({
      try decodeIfPresent(T.self, forKey: key)
    }, safeOptionalDecoding: safeOptionalDecoding)
  }

  func decodeAny<T>(_ key: K) throws -> T {
    try decodeAny(T.self, forKey: key)
  }

  func decodeAnyIfPresent<T>(_ key: K) throws -> T? {
    try decodeAnyIfPresent(T.self, forKey: key)
  }

  func decodeArray<T: Decodable>(
    _ key: K,
    safeArrayDecoding: Bool = false
  ) throws -> [T] {
    var container: UnkeyedDecodingContainer
    var array: [T] = []

    do {
      container = try nestedUnkeyedContainer(forKey: key)
    } catch {
      if safeArrayDecoding {
        return array
      } else {
        throw error
      }
    }

    while !container.isAtEnd {
      do {
        let element = try container.decode(T.self)
        array.append(element)
      } catch {
        if safeArrayDecoding {
          // hack to advance the current index
          _ = try? container.decode(AnyCodable.self)
        } else {
          throw error
        }
      }
    }
    return array
  }

  func decodeArrayIfPresent<T: Decodable>(_ key: K) throws -> [T]? {
    try decodeOptional {
      if contains(key) {
        return try decodeArray(key)
      } else {
        return nil
      }
    }
  }

  private func decodeOptional<T>(
    _ closure: () throws -> T?, safeOptionalDecoding: Bool = false
  ) throws -> T? {
    if safeOptionalDecoding {
      do {
        return try closure()
      } catch {
        return nil
      }
    } else {
      return try closure()
    }
  }
}
