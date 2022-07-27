import FloxBxNetworking

public struct SignUpRequest: ClientBodySuccessRequest {
  public init(body: CreateUserRequestContent) {
    self.body = body
  }
  
  public let body: CreateUserRequestContent

  public var headers: [String: String] {
    [:]
  }

  public static var requiresCredentials: Bool {
    false
  }

  public var path: String {
    "api/v1/users"
  }

  public var parameters: [String: String] {
    [:]
  }

  public typealias BodyType = CreateUserRequestContent

  public typealias SuccessType = CreateUserResponseContent

  public var method: RequestMethod { .POST }
}
