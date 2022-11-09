import Foundation
public struct CreateTodoRequestContent: Codable {
  public let title: String

  public init(title: String) {
    self.title = title
  }
}
