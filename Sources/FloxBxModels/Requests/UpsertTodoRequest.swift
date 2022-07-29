import FloxBxNetworking
import Foundation

public struct UpsertTodoRequest: ClientBodySuccessRequest {
  public init(groupSessionID: UUID?, itemID: UUID?, body: UpsertTodoRequest.BodyType) {
    self.groupSessionID = groupSessionID
    self.itemID = itemID
    self.body = body
  }

  public let groupSessionID: UUID?
  public let itemID: UUID?
  public let body: BodyType

  public typealias SuccessType = CreateTodoResponseContent

  public typealias BodyType = CreateTodoRequestContent

  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    var path = "api/v1/"
    if let groupSessionID = groupSessionID {
      path.append("group-sessions/\(groupSessionID)/")
    }
    path.append("todos")

    if let itemID = itemID {
      path.append("/\(itemID)")
    }

    return path
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: RequestMethod {
    itemID != nil ? .PUT : .POST
  }

  public var headers: [String: String] {
    [:]
  }
}
