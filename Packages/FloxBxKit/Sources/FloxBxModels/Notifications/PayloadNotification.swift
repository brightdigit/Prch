import Foundation

public struct PayloadNotification<Payload: Codable>: Codable {
  public let topic: String
  public let deviceToken: Data
  public let payload: Payload

  public init(topic: String, deviceToken: Data, payload: Payload) {
    self.topic = topic
    self.deviceToken = deviceToken
    self.payload = payload
  }
}

extension PayloadNotification: Notifiable where Payload: NotificationContent {
  public var title: String {
    payload.title
  }
}
