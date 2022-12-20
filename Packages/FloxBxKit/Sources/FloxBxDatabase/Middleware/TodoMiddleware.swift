import FloxBxModels
import FluentKit
import Foundation

struct TodoMiddleware: AsyncModelMiddleware, SendsNotifications {
  typealias Model = Todo
  typealias PayloadModelType = TagPayload

  // swiftformat:disable:next all
  let sendNotification: (PayloadNotification<TagPayload>) async throws -> UUID?

  func delete(model: Todo, force: Bool, on db: Database, next: AnyAsyncModelResponder) async throws {
    let query = model.$tags.query(on: db)
    let tags = try await query.all().compactMap(\.id)
    let devices = try await query.with(\.$subscribers) { subscriber in
      subscriber.with(\.$mobileDevices)
    }.all().flatMap(\.subscribers).flatMap(\.mobileDevices)

    try await withThrowingTaskGroup(of: Void.self) { _ in
      for tagID in tags {
        let payload = TagPayload(action: .removed, name: tagID)
        try await self.sendPayload(payload, to: devices, on: db)
      }
    }

    try await next.delete(model, force: force, on: db)
  }
}
