import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct JSONCoder: Coder {
  func encode<CodableType>(_ value: CodableType) throws -> Data where CodableType: Encodable {
    try encoder.encode(value)
  }

  func decode<CodableType>(_ type: CodableType.Type, from data: Data) throws -> CodableType where CodableType: Decodable {
    try decoder.decode(type, from: data)
  }

  typealias DataType = Data

  internal init(encoder: JSONEncoder, decoder: JSONDecoder) {
    self.encoder = encoder
    self.decoder = decoder
  }

  let encoder: JSONEncoder
  let decoder: JSONDecoder
}
