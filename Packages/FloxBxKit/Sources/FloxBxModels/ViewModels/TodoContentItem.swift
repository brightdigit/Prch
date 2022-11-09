import Foundation

public struct TodoContentItem: Identifiable, Codable {
  public let clientID: UUID
  public let serverID: UUID?
  public var title: String

  public var isSaved: Bool {
    serverID != nil
  }

  public var id: UUID {
    clientID
  }

  public init(title: String, clientID: UUID = .init(), serverID: UUID? = nil) {
    self.clientID = clientID
    self.serverID = serverID
    self.title = title
  }

  public init(content: CreateTodoResponseContent) {
    self.init(title: content.title, clientID: content.id, serverID: content.id)
  }
}

extension TodoContentItem {
  public func updatingTitle(_ title: String) -> TodoContentItem {
    TodoContentItem(title: title, clientID: clientID, serverID: serverID)
  }
}
