import FloxBxModels
import Foundation

struct DeviceNotification<PayloadModelType: PayloadModel> {
  internal init(deviceID: UUID, payloadNotification: PayloadNotification<PayloadModelType>) {
    self.deviceID = deviceID
    self.payloadNotification = payloadNotification
  }

  init?(device: MobileDevice, payload: PayloadModelType) {
    guard let deviceToken = device.deviceToken, let deviceID = device.id else {
      return nil
    }
    let payloadNotification = PayloadNotification(topic: device.topic, deviceToken: deviceToken, payload: payload)
    self.init(deviceID: deviceID, payloadNotification: payloadNotification)
  }

  let deviceID: UUID
  let payloadNotification: PayloadNotification<PayloadModelType>
}
