public protocol ClientRequest: ClientBaseRequest {
  associatedtype SuccessType
  associatedtype BodyType

  var body: BodyType { get }
}

extension ClientRequest {
  public var actualPath: String {
    guard !path.hasPrefix("/") else {
      return path
    }

    return "/\(path)"
  }
}
