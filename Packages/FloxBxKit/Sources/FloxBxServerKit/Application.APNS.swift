import FloxBxModels
import Foundation
import Vapor

extension Application {
  public func sendNotification<NotifiableType: Notifiable>(_ notification: NotifiableType) async throws -> UUID? {
    try await apns.client.sendAlertNotification(
      .init(
        alert: .init(title: .raw(notification.title)),
        expiration: .immediately,
        priority: .immediately,
        topic: notification.topic,
        payload: notification.payload
      ),
      deviceToken: notification.deviceToken.map { data in String(format: "%02.2hhx", data) }.joined(),
      deadline: .distantFuture
    ).apnsID
  }
}
