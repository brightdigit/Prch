import FloxBxNetworking
import Foundation

public struct CreateGroupSessionResponseContent: Codable {
  public let id: UUID

  public init(id: UUID) {
    self.id = id
  }
}

public struct CreateGroupSessionRequest: ClientSuccessRequest {
  public typealias SuccessType = CreateGroupSessionResponseContent

  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    "api/v1/group-sessions"
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: RequestMethod {
    .POST
  }

  public var headers: [String: String] {
    [:]
  }

  public init() {}
}
