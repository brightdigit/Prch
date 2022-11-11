import Foundation

public struct GetUserResponseContent: Codable {
  private let id: UUID
  private let username: String
  public init(id: UUID, username: String) {
    self.id = id
    self.username = username
  }
}
