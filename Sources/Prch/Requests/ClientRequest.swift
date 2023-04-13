import PrchModel

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
