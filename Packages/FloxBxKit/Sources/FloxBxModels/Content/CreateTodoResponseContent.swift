import Foundation

public struct CreateTodoResponseContent: Codable {
  public let id: UUID
  public let title: String
  public init(id: UUID, title: String) {
    self.id = id
    self.title = title
  }
}
