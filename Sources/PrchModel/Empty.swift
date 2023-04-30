public struct Empty: ContentDecodable, ContentEncodable, Equatable {
  public static func decode<CoderType>(
    _: CoderType.DataType,
    using _: CoderType
  ) throws where CoderType: Coder {}

  public static var decodable: Void.Type {
    Void.self
  }

  public typealias DecodableType = Void

  public var encodable: EncodableValue {
    .empty
  }

  public static let value = Empty()

  internal init() {}

  public init(decoded _: Void) throws {}
}
