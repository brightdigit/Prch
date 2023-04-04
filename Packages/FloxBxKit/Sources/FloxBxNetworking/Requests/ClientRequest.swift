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

public protocol ClientRequest: ClientBaseRequest {
  associatedtype SuccessType : ContentDecodable
  associatedtype BodyType : ContentEncodable

  var body: BodyType { get }

  func isValidStatusCode(_ statusCode: Int) -> Bool
}

extension ClientRequest {
  public var actualPath: String {
    guard !path.hasPrefix("/") else {
      return path
    }

    return "/\(path)"
  }

  public func isValidStatusCode(_ statusCode: Int) -> Bool {
    statusCode / 100 == 2
  }
}
