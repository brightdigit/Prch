import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif
public protocol LegacyCoder  {
  associatedtype DataType

  func encode<CodableType: Encodable>(_ value: CodableType) throws -> DataType

  func decode<CodableType: Decodable>(_: CodableType.Type, from data: DataType)
    throws -> CodableType
}
public protocol Coder : LegacyCoder{
}

enum CoderError : Error {
  case missingData
  case missingDecoding
}

public struct Empty : ContentDecodable, ContentEncodable, Decodable {  
  public typealias DecodableType = Empty
  
  public var encodable: EncodableValue {
    return .empty
  }
  
  static public var decodable: Empty? {
    return nil
  }
  
  public static let value = Empty()
  
  internal init () {}
  
  public init(decoded: Empty?) throws {
    
  }
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
