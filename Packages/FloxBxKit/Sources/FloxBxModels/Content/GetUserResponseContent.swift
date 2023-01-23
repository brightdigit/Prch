import Foundation

public struct GetUserResponseContent: Codable {
  private let id: UUID
  private let username: String
  private let tags: [String]
  public init(id: UUID, username: String, tags: [String]) {
    self.id = id
    self.username = username
    self.tags = tags
  }
}
