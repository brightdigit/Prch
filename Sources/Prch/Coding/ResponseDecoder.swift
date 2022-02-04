import Foundation

public protocol ResponseDecoder {
  func decode<T: Decodable>(_ type: T.Type, from: Data) throws -> T
}

extension JSONDecoder: ResponseDecoder {}

public extension ResponseDecoder {
  func decodeAny<T>(_: T.Type, from data: Data) throws -> T {
    guard let decoded = try decode(AnyCodable.self, from: data) as? T else {
      throw DecodingError.mismatch(ofType: T.self)
    }
    return decoded
  }
}
