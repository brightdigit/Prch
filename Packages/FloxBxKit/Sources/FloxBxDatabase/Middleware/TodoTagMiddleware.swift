import FloxBxModels
import FluentKit
import Foundation

struct TodoTagMiddleware: AsyncModelMiddleware, SendsNotifications {
  typealias Model = TodoTag
  typealias PayloadModelType = TagPayload

  // swiftformat:disable:next all
  let sendNotification: (PayloadNotification<TagPayload>) async throws -> UUID?

  func create(model: TodoTag, on db: Database, next: AnyAsyncModelResponder) async throws {
    let devices = try await model.$tag.query(on: db).with(\.$subscribers) { subscriber in
      subscriber.with(\.$mobileDevices)
    }.all().flatMap(\.subscribers).flatMap(\.mobileDevices)

    let payload = TagPayload(action: .added, name: model.$tag.id)
    try await sendPayload(payload, to: devices, on: db)

    try await next.create(model, on: db)
  }

  func delete(model: TodoTag, force: Bool, on db: Database, next: AnyAsyncModelResponder) async throws {
    let devices = try await model.$tag.query(on: db).with(\.$subscribers) { subscriber in
      subscriber.with(\.$mobileDevices)
    }.all().flatMap(\.subscribers).flatMap(\.mobileDevices)

    let payload = TagPayload(action: .removed, name: model.$tag.id)
    try await sendPayload(payload, to: devices, on: db)
    return try await next.delete(model, force: force, on: db)
  }
}
