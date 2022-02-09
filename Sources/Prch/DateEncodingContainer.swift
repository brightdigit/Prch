import Foundation

public protocol DateEncodingContainer {
  static var dateEncodingFormatter: DateFormatter { get }
}

public extension DateEncodingContainer where Self: API {
  var decoder: ResponseDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Self.dateEncodingFormatter)
    return decoder
  }

  var encoder: RequestEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(Self.dateEncodingFormatter)
    return encoder
  }
}
