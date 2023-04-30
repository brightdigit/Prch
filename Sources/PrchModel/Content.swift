public enum EncodableValue {
  case encodable(Encodable)
  case empty
}

public protocol ContentEncodable {
  var encodable: EncodableValue { get }
}

public protocol ContentDecodable {
  associatedtype DecodableType
  static var decodable: DecodableType.Type { get }
  init(decoded: DecodableType) throws
  static func decode<CoderType: Coder>(
    _ data: CoderType.DataType,
    using coder: CoderType
  ) throws -> DecodableType
}

public typealias Content = ContentEncodable & ContentDecodable

extension Encodable where Self: ContentEncodable {
  public var encodable: EncodableValue {
    .encodable(self)
  }
}

extension Decodable
  where Self: ContentDecodable, DecodableType == Self {
  public static var decodable: Self.Type {
    Self.self
  }

  public init(decoded: DecodableType) throws {
    self = decoded
  }

  public static func decode<CoderType>(
    _ data: CoderType.DataType,
    using coder: CoderType
  ) throws -> Self where CoderType: Coder {
    try coder.decode(Self.self, from: data)
  }
}

extension Array: ContentDecodable
  where Element: ContentDecodable & Decodable, Element.DecodableType == Element {
  public static func decode<CoderType>(
    _ data: CoderType.DataType,
    using coder: CoderType
  ) throws -> [Element.DecodableType] where CoderType: Coder {
    try coder.decode([Element.DecodableType].self, from: data)
  }

  public static var decodable: [Element.DecodableType].Type {
    Self.self
  }

  public init(decoded: [Element.DecodableType]) throws {
    self = decoded
  }

  public typealias DecodableType = [Element.DecodableType]
}
