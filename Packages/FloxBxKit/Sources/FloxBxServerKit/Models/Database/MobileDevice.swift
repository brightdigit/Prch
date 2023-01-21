import FloxBxDatabase
import FloxBxModels
import Foundation

extension MobileDevice {
  internal convenience init(content: CreateMobileDeviceRequestContent) {
    self.init(
      model: content.model,
      operatingSystem: content.operatingSystem,
      topic: content.topic,
      deviceToken: content.deviceToken
    )
  }

  internal func patch(content: PatchMobileDeviceRequestContent) {
    deviceToken = content.deviceToken ?? deviceToken
    operatingSystem = content.operatingSystem ?? operatingSystem
    model = content.model ?? model
    topic = content.topic ?? topic
  }
}
