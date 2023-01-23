import FloxBxModels
import FluentKit
import Foundation

internal protocol SendsNotifications {
  associatedtype PayloadModelType: PayloadModel

  // swiftlint:disable line_length
  // swiftformat:disable:next all
  var sendNotification: (PayloadNotification<PayloadModelType>) async throws -> UUID? { get }
  // swiftlint:enable line_length
}

extension SendsNotifications {
  internal func sentNotification(
    basedOn deviceNotification: DeviceNotification<PayloadModelType>
  ) async throws -> Notification? {
    guard let sentNotificationID =
      try await sendNotification(deviceNotification.payloadNotification) else {
      return nil
    }
    return Notification(id: sentNotificationID, deviceNotification: deviceNotification)
  }

  internal func sendNotifications(
    _ notifications: [DeviceNotification<PayloadModelType>]
  ) async throws -> [Notification] {
    try await withThrowingTaskGroup(of: Notification?.self) { group -> [Notification] in
      for deviceNotification in notifications {
        group.addTask { () -> Notification? in
          try await sentNotification(basedOn: deviceNotification)
        }
      }
      return try await group.reduce(into: [Notification]()) { models, notification in
        guard let notification = notification else {
          return
        }
        models.append(notification)
      }
    }
  }

  internal func sendPayload(
    _ payload: PayloadModelType,
    to devices: [MobileDevice],
    on database: Database
  ) async throws {
    let notifications = devices.compactMap {
      DeviceNotification(device: $0, payload: payload)
    }

    let models = try await sendNotifications(notifications)

    try await models.create(on: database)
  }
}
