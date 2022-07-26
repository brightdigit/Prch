import Foundation
public struct GetTodoListRequest: ClientSuccessRequest {
  public typealias SuccessType = [CreateTodoResponseContent]

  public typealias BodyType = Void
  
  let groupSessionID : UUID?

  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    
      var path = "api/v1/"
      if let groupSessionID = groupSessionID {
        path.append("group-sessions/\(groupSessionID)/")
        
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
