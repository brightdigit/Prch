import FloxBxModels
import FluentKit
import Foundation

extension Databases.Middleware {
  public func configure(
    notify: @escaping (PayloadNotification<TagPayload>) async throws -> UUID?
  ) {
    use(TagMiddleware())
    use(TodoMiddleware(sendNotification: notify))
    use(TodoTagMiddleware(sendNotification: notify))
  }
}
