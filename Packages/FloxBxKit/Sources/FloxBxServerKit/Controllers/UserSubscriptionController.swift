import FloxBxDatabase
import FloxBxModels
import Foundation
import RouteGroups
import Vapor

struct UserSubscriptionController: RouteGroupCollection {
  var routeGroups: [RouteGroupKey: RouteGroups.RouteCollectionBuilder] {
    [
      .bearer: { bearer in
        bearer.post("subscriptions", use: self.create(from:))
        bearer.delete("subscriptions", use: self.delete(from:))
      }
    ]
  }

  typealias RouteGroupKeyType = RouteGroupKey

  func create(from request: Request) async throws -> HTTPStatus {
    let user: User = try request.auth.require()
    let content: UserSubscriptionRequestContent = try request.content.decode(UserSubscriptionRequestContent.self)
    let tags = try await Tag.findOrCreate(tagValues: content.tags, on: request.db)
    try await user.$tags.attach(tags, on: request.db)
    return .created
  }

  func delete(from request: Request) async throws -> HTTPStatus {
    let user: User = try request.auth.require()
    let content: UserSubscriptionRequestContent = try request.content.decode(UserSubscriptionRequestContent.self)
    let tags = try await Tag.find(tagValues: content.tags, on: request.db)
    try await user.$tags.detach(tags, on: request.db)
    return .noContent
  }
}
