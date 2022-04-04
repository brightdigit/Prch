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
  public init(title: String) {
    self.init(id: .init(), title: title, isSaved: false)
  }

  public init(content: CreateTodoResponseContent) {
    self.init(id: content.id, title: content.title, isSaved: true)
  }

  public init(id: UUID, title: String, isSaved: Bool) {
    self.id = id
    self.title = title
    self.isSaved = isSaved
  }

  public let id: UUID
  public var title: String
  public let isSaved: Bool
}
