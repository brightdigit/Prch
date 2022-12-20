import APNSwift
import FloxBxModels
import Foundation

extension Notifiable {
  var alertNotification: APNSAlertNotification<PayloadType> {
    .init(
      alert: .init(title: .raw(title)),
      expiration: .immediately,
      priority: .immediately,
      topic: topic,
      payload: payload
    )
  }
}
