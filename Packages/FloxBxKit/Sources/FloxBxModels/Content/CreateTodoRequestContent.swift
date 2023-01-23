import Foundation
public struct CreateTodoRequestContent: Codable {
  public let title: String
  public let tags: [String]

  public init(title: String, tags: [String]) {
    self.title = title
    self.tags = tags
  }
}
