import Foundation

public struct TodoContentItem: Identifiable, Codable {
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

  public var isSaved: Bool {
    serverID != nil
  }

  public var id: UUID {
    clientID
  }
}

extension TodoContentItem {
  func updatingTitle(_ title: String) -> TodoContentItem {
    TodoContentItem(clientID: clientID, serverID: serverID, title: title)
  }
}
