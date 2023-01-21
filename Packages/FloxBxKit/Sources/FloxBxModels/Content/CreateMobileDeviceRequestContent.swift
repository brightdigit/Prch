import Foundation
public struct CreateMobileDeviceRequestContent: Codable {
  public let model: String
  public let operatingSystem: String
  public let topic: String
  public let deviceToken: Data?

  public init(
    model: String,
    operatingSystem: String,
    topic: String,
    deviceToken: Data? = nil
  ) {
    self.model = model
    self.operatingSystem = operatingSystem
    self.topic = topic
    self.deviceToken = deviceToken
  }
}
