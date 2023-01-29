import FloxBxModels
import FluentKit
import Foundation

@available(iOS 15, *)
extension Databases.Middleware {
  public func configure(
    notify: @escaping (PayloadNotification<TagPayload>) async throws -> UUID?
  ) {
    use(TagMiddleware())
    use(TodoMiddleware(sendNotification: notify))
    use(TodoTagMiddleware(sendNotification: notify))
  }
}
