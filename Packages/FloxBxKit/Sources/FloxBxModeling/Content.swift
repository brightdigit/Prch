public enum EncodableValue {
  case encodable(Encodable)
  case empty
}

public protocol ContentEncodable {
  var encodable : EncodableValue { get }
}

public protocol ContentDecodable {
  associatedtype DecodableType : Decodable
  static var decodable : DecodableType.Type? { get }
  init(decoded : DecodableType?) throws
}

public typealias Content = ContentEncodable & ContentDecodable

extension Encodable where Self : ContentEncodable {
  public var encodable : EncodableValue {
    return .encodable(self)
  }
}
extension Decodable where Self : ContentDecodable, DecodableType == Self {
  public static var decodable : Self.Type? {
    return Self.self
  }
  public init(decoded : DecodableType?) throws {
    guard let decoded = decoded else {
      throw CoderError.missingDecoding
    }
    self = decoded
  }
}
