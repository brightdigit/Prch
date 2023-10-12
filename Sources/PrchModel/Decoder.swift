public protocol Decoder<DataType> {
  associatedtype DataType

  func decode<CodableType: Decodable>(
    _: CodableType.Type,
    from data: DataType
  )
    throws -> CodableType
}

extension Decoder {
  public func decodeContent<CodableType: ContentDecodable>(
    _: CodableType.Type,
    code: Int,
    from data: DataType
  )
    throws -> CodableType.DecodableType {
      try CodableType.decode(data, code: code, using: self)
  }
}
