import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct DeleteTodoItemRequest: ClientVoidRequest {
  let groupSessionID: UUID?
  let itemID: UUID
  static var requiresCredentials: Bool {
    true
  }

  var path: String {
    var path = "api/v1/"
    if let groupSessionID = groupSessionID {
      path.append("group-sessions/\(groupSessionID)/")
      
    }
                  path.append("todos/\(itemID)")
                  
                  return path
  }

  var parameters: [String: String] {
    [:]
  }

  var method: RequestMethod {
    .DELETE
  }

  var headers: [String: String] {
    [:]
  }
}
