import Foundation

public struct CreateMobileDeviceResponseContent: Codable {
  public let id: UUID

  public init(id: UUID) {
    self.id = id
  }
}
