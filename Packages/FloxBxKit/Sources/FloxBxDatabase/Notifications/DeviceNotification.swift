import FloxBxModels
import Foundation

internal struct DeviceNotification<PayloadModelType: PayloadModel> {
  internal let deviceID: UUID
  internal let payloadNotification: PayloadNotification<PayloadModelType>

  private init(
    deviceID: UUID,
    payloadNotification: PayloadNotification<PayloadModelType>
  ) {
    self.deviceID = deviceID
    self.payloadNotification = payloadNotification
  }

  internal init?(device: MobileDevice, payload: PayloadModelType) {
    guard let deviceToken = device.deviceToken, let deviceID = device.id else {
      return nil
    }
    let payloadNotification = PayloadNotification(
      topic: device.topic,
      deviceToken: deviceToken,
      payload: payload
    )
    self.init(deviceID: deviceID, payloadNotification: payloadNotification)
  }
}
