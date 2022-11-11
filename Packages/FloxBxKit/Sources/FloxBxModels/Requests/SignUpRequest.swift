import FloxBxNetworking

public struct SignUpRequest: ClientBodySuccessRequest {
  public typealias BodyType = CreateUserRequestContent

  public typealias SuccessType = CreateUserResponseContent
  public static var requiresCredentials: Bool {
    false
  }

  public let body: CreateUserRequestContent

  public var headers: [String: String] {
    [:]
  }

  public var path: String {
    "api/v1/users"
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: RequestMethod { .POST }

  public init(body: CreateUserRequestContent) {
    self.body = body
  }
}
