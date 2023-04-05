import Foundation
import FloxBxModeling

public struct CreateMobileDeviceResponseContent: Codable, Content {
  public let id: UUID

  public init(id: UUID) {
    self.id = id
  }
}
