import FloxBxNetworking
import Foundation
public struct GetTodoListRequest: ClientSuccessRequest {
  public init(groupActivityID: UUID? = nil) {
    self.groupActivityID = groupActivityID
  }

  public typealias SuccessType = [CreateTodoResponseContent]

  public typealias BodyType = Void

  let groupActivityID: UUID?

  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    var path = "api/v1/"
    if let groupActivityID = groupActivityID {
      path.append("group-sessions/\(groupActivityID)/")
    }
    path.append("todos")

    return path
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
