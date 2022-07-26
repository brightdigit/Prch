import Foundation

public struct CreateTodoResponseContent: Codable {
  public init(id: UUID, title: String) {
    self.id = id
    self.title = title
  }

  public let id: UUID
  public let title: String
}
