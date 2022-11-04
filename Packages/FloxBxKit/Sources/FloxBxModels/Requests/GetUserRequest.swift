import FloxBxNetworking
import Foundation

public struct GetUserRequest: ClientSuccessRequest {
  public typealias SuccessType = GetUserResponseContent

  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    "api/v1/users"
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: RequestMethod {
    .GET
  }

  public var headers: [String: String] {
    [:]
  }
}
