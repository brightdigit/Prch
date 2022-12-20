import FloxBxModels
import FluentKit
import Foundation

protocol SendsNotifications {
  associatedtype PayloadModelType: PayloadModel

  // swiftformat:disable:next all
  var sendNotification: (PayloadNotification<PayloadModelType>) async throws -> UUID? { get }
}

extension SendsNotifications {
  func sentNotification(basedOn deviceNotification: DeviceNotification<PayloadModelType>) async throws -> Notification? {
    guard let id = try await sendNotification(deviceNotification.payloadNotification) else {
      return nil
    }
    return Notification(id: id, deviceNotification: deviceNotification)
  }

  func sendNotifications(_ notifications: [DeviceNotification<PayloadModelType>]) async throws -> [Notification] {
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

  func sendPayload(_ payload: PayloadModelType, to devices: [MobileDevice], on db: Database) async throws {
    let notifications = devices.compactMap {
      DeviceNotification(device: $0, payload: payload)
    }

    let models = try await sendNotifications(notifications)

    try await models.create(on: db)
  }
}
