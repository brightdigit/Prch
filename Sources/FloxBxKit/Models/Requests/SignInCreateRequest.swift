public struct SignInCreateRequest: ClientBodySuccessRequest {
  public let body: BodyType

  public typealias SuccessType = CreateTokenResponseContent

  public typealias BodyType = CreateTokenRequestContent

  public static let requiresCredentials: Bool = false

  public let path: String = "api/v1/tokens"

  public var parameters: [String: String] {
    [:]
  }

  public let method: RequestMethod = .POST

  public var headers: [String: String] {
    [:]
  }
}
