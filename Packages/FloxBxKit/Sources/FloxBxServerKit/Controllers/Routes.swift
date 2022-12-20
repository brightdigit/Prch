import FloxBxDatabase
import RouteGroups
import Vapor

struct Routes: GroupCollection {
  typealias RouteGroupKeyType = RouteGroupKey

  func groupBuilder(routes: RoutesBuilder) -> GroupBuilder<RouteGroupKey> {
    let api = routes.grouped("api", "v1")
    let bearer = api.grouped(UserToken.authenticator())

    return GroupBuilder<RouteGroupKey>(groups: [
      .bearer: bearer,
      .publicAPI: api
    ])
  }

  func boot(groups: GroupBuilder<RouteGroupKey>) throws {
    try groups.register(collection: UserTokenController())
    try groups.register(collection: UserController())
    try groups.register(collection: TodoController())
    try groups.register(collection: GroupSessionController())

    try groups.register(collection: MobileDeviceController())
    try groups.register(collection: UserSubscriptionController())
  }
}
