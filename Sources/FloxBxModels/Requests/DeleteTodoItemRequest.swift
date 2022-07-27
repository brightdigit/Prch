import Foundation
import FloxBxNetworking
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct DeleteTodoItemRequest: ClientVoidRequest {
  public init(groupSessionID: UUID? = nil, itemID: UUID) {
    self.groupSessionID = groupSessionID
    self.itemID = itemID
  }
  
  let groupSessionID: UUID?
  let itemID: UUID
  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    var path = "api/v1/"
    if let groupSessionID = groupSessionID {
      path.append("group-sessions/\(groupSessionID)/")
      
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
