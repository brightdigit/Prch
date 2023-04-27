import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
@available(*, deprecated)
public protocol LegacyCoder<DataType> {
  associatedtype DataType

  func encode<CodableType: Encodable>(_ value: CodableType) throws -> DataType

  func decode<CodableType: Decodable>(_: CodableType.Type, from data: DataType)
    throws -> CodableType
}

public protocol Coder<DataType> {
  associatedtype DataType

  func encode<CodableType: Encodable>(_ value: CodableType) throws -> DataType

  func decode<CodableType: Decodable>(_: CodableType.Type, from data: DataType)
    throws -> CodableType
}

enum CoderError: Error {
  case missingData
  case missingDecoding
}

public struct Empty: ContentDecodable, ContentEncodable, Decodable {
  public typealias DecodableType = Empty

  public var encodable: EncodableValue {
    .empty
  }

  public static var decodable: Empty? {
    nil
  }

  public static let value = Empty()

  internal init() {}

  public init(decoded _: Empty?) throws {}
}

public struct JSONCoder: Coder {
  public typealias DataType = Data

  private let encoder: JSONEncoder
  private let decoder: JSONDecoder

  public init(encoder: JSONEncoder, decoder: JSONDecoder) {
    self.encoder = encoder
    self.decoder = decoder
  }

  public func encode<CodableType>(
    _ value: CodableType
  ) throws -> Data where CodableType: Encodable {
    try encoder.encode(value)
  }

  public func decode<CodableType>(
    _ type: CodableType.Type,
    from data: Data
  ) throws -> CodableType where CodableType: Decodable {
    try decoder.decode(type, from: data)
  }
}
