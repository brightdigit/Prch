import FloxBxModels
import FluentKit
import Foundation

@available(iOS 15, *)
internal struct TodoMiddleware: AsyncModelMiddleware, SendsNotifications {
  internal typealias Model = Todo
  internal typealias PayloadModelType = TagPayload

  // swiftformat:disable:next all
  internal let sendNotification: (PayloadNotification<TagPayload>) async throws -> UUID?

  internal func delete(
    model: Todo,
    force: Bool,
    on db: Database,
    next: AnyAsyncModelResponder
  ) async throws {
    let query = model.$tags.query(on: db)
    let tags = try await query.all().compactMap(\.id)
    let devices = try await query
      .with(\.$subscribers) { subscriber in
        subscriber.with(\.$mobileDevices)
      }
      .all()
      .flatMap(\.subscribers)
      .flatMap(\.mobileDevices)

    try await withThrowingTaskGroup(of: Void.self) { _ in
      for tagID in tags {
        let payload = TagPayload(action: .removed, name: tagID)
        try await self.sendPayload(payload, to: devices, on: db)
      }
    }

    try await next.delete(model, force: force, on: db)
  }
}
