import Foundation

public struct CreateTodoResponseContent : Codable, Identifiable {
  public init(id: UUID = .init(), title: String) {
    self.id = id
    self.title = title
  }
  
  public let id: UUID
  public let title: String
}

public typealias TodoContentItem = CreateTodoResponseContent
