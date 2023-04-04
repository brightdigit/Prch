public protocol LegacyClientRequest: ClientBaseRequest {
  associatedtype SuccessType
  associatedtype BodyType

  var body: BodyType { get }

  func isValidStatusCode(_ statusCode: Int) -> Bool
}

extension LegacyClientRequest {
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
