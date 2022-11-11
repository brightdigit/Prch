public protocol Coder {
  associatedtype DataType

  func encode<CodableType: Encodable>(_ value: CodableType) throws -> DataType

  func decode<CodableType: Decodable>(_: CodableType.Type, from data: DataType)
    throws -> CodableType
}
