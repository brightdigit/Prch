import FloxBxModels
import FloxBxNetworking

public struct SignInCreateRequest: ClientBodySuccessRequest {
  public typealias SuccessType = CreateTokenResponseContent

  public typealias BodyType = CreateTokenRequestContent

  public static let requiresCredentials = false

  public let body: BodyType

  public let path: String = "api/v1/tokens"

  public var parameters: [String: String] {
    [:]
  }

  public let method: RequestMethod = .POST

  public var headers: [String: String] {
    [:]
  }

  public init(body: SignInCreateRequest.BodyType) {
    self.body = body
  }
}
