import Foundation

public struct CreateTodoResponseContent: Codable {
  public let id: UUID
  public let title: String
  public let tags: [String]
  public init(id: UUID, title: String, tags: [String]) {
    self.id = id
    self.title = title
    self.tags = tags
  }
}
