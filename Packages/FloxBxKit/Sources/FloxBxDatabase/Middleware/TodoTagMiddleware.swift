import FloxBxModels
import FluentKit
import Foundation

@available(iOS 15, *)
internal struct TodoTagMiddleware: AsyncModelMiddleware, SendsNotifications {
  internal typealias Model = TodoTag
  internal typealias PayloadModelType = TagPayload

  // swiftformat:disable:next all
  internal let sendNotification: (PayloadNotification<TagPayload>) async throws -> UUID?

  internal func create(
    model: TodoTag,
    on db: Database,
    next: AnyAsyncModelResponder
  ) async throws {
    let devices = try await model.$tag.query(on: db)
      .with(\.$subscribers) { subscriber in
        subscriber.with(\.$mobileDevices)
      }
      .all()
      .flatMap(\.subscribers)
      .flatMap(\.mobileDevices)

    let payload = TagPayload(action: .added, name: model.$tag.id)
    try await sendPayload(payload, to: devices, on: db)

    try await next.create(model, on: db)
  }

  internal func delete(
    model: TodoTag,
    force: Bool,
    on db: Database,
    next: AnyAsyncModelResponder
  ) async throws {
    let devices = try await model.$tag.query(on: db)
      .with(\.$subscribers) { subscriber in
        subscriber.with(\.$mobileDevices)
      }
      .all()
      .flatMap(\.subscribers)
      .flatMap(\.mobileDevices)

    let payload = TagPayload(action: .removed, name: model.$tag.id)
    try await sendPayload(payload, to: devices, on: db)
    return try await next.delete(model, force: force, on: db)
  }
}
