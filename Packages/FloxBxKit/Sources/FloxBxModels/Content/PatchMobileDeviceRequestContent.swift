import Foundation
import FloxBxModeling
public struct PatchMobileDeviceRequestContent: Content, Codable {
  public let model: String?
  public let operatingSystem: String?
  public let topic: String?
  public let deviceToken: Data?

  public init(
    model: String? = nil,
    operatingSystem: String? = nil,
    topic: String? = nil,
    deviceToken: Data? = nil
  ) {
    self.model = model
    self.operatingSystem = operatingSystem
    self.topic = topic
    self.deviceToken = deviceToken
  }

  public init(createContent: CreateMobileDeviceRequestContent) {
    self.init(
      model: createContent.model,
      operatingSystem: createContent.operatingSystem,
      topic: createContent.topic,
      deviceToken: createContent.deviceToken
    )
  }
}
