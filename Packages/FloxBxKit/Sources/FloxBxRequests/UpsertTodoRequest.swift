import FloxBxModels
import FloxBxNetworking
import Foundation

public struct UpsertTodoRequest: ClientBodySuccessRequest {
  public typealias SuccessType = CreateTodoResponseContent

  public typealias BodyType = CreateTodoRequestContent

  public static var requiresCredentials: Bool {
    true
  }

  public let groupActivityID: UUID?
  public let itemID: UUID?
  public let body: BodyType

  public var path: String {
    var path = "api/v1/"
    if let groupActivityID = groupActivityID {
      path.append("group-sessions/\(groupActivityID)/")
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

  public init(groupActivityID: UUID?, itemID: UUID?, body: UpsertTodoRequest.BodyType) {
    self.groupActivityID = groupActivityID
    self.itemID = itemID
    self.body = body
  }
}
