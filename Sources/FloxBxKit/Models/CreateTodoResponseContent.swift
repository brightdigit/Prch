import Foundation

public struct CreateTodoResponseContent: Codable {
  public init(id: UUID, title: String) {
    self.id = id
    self.title = title
  }

  public let id: UUID
  public let title: String
}

public struct TodoContentItem: Identifiable {
  internal init(clientID: UUID = .init(), serverID: UUID? = nil, title: String) {
    self.clientID = clientID
    self.serverID = serverID
    self.title = title
  }
  

  public init(content: CreateTodoResponseContent) {
    self.init(clientID: content.id, serverID: content.id, title: content.title)
  }
  public let clientID: UUID
  public let serverID: UUID?
  public var title: String
  
  public var isSaved : Bool {
    return serverID != nil
  }
  
  public var id : UUID {
    return self.clientID
  }
}
