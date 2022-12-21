import Foundation
public struct CreateGroupSessionResponseContent: Codable {
  public let id: UUID

  public init(id: UUID) {
    self.id = id
  }
}
