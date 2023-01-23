import FloxBxDatabase
import RouteGroups
import Vapor

internal struct Routes: GroupCollection {
  internal typealias RouteGroupKeyType = RouteGroupKey

  internal func groupBuilder(routes: RoutesBuilder) -> GroupBuilder<RouteGroupKey> {
    let api = routes.grouped("api", "v1")
    let bearer = api.grouped(UserToken.authenticator())

    return GroupBuilder<RouteGroupKey>(groups: [
      .bearer: bearer,
      .publicAPI: api
    ])
  }

  internal func boot(groups: GroupBuilder<RouteGroupKey>) throws {
    try groups.register(collection: UserTokenController())
    try groups.register(collection: UserController())
    try groups.register(collection: TodoController())
    try groups.register(collection: GroupSessionController())

    try groups.register(collection: MobileDeviceController())
    try groups.register(collection: UserSubscriptionController())
  }
}
