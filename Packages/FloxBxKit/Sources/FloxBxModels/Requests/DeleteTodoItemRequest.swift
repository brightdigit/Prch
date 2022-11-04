import FloxBxNetworking
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct DeleteTodoItemRequest: ClientVoidRequest {
  public init(groupActivityID: UUID? = nil, itemID: UUID) {
    self.groupActivityID = groupActivityID
    self.itemID = itemID
  }

  let groupActivityID: UUID?
  let itemID: UUID
  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    var path = "api/v1/"
    if let groupActivityID = groupActivityID {
      path.append("group-sessions/\(groupActivityID)/")
    }
    path.append("todos/\(itemID)")

    return path
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: RequestMethod {
    .DELETE
  }

  public var headers: [String: String] {
    [:]
  }
}
