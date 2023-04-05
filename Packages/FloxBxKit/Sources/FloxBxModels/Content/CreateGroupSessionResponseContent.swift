import Foundation
import FloxBxModeling
public struct CreateGroupSessionResponseContent: Codable, Content {
  public let id: UUID

  public init(id: UUID) {
    self.id = id
  }
}
