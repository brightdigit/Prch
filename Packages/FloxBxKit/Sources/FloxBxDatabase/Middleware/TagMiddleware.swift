import FloxBxUtilities
import FluentKit
import Foundation

internal struct TagMiddleware: AsyncModelMiddleware {
  internal typealias Model = Tag

  internal func create(
    model: Tag,
    on db: Database,
    next: AnyAsyncModelResponder
  ) async throws {
    model.id = model.id?.slugified()
    try await next.create(model, on: db)
  }

  internal func update(
    model: Tag,
    on db: Database,
    next: AnyAsyncModelResponder
  ) async throws {
    model.id = model.id?.slugified()
    try await next.update(model, on: db)
  }
}
