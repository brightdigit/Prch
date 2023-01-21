import FloxBxDatabase
import FloxBxModels
import Fluent
import RouteGroups
import Vapor

internal struct GroupSessionController: RouteGroupCollection {
  internal typealias RouteGroupKeyType = RouteGroupKey

  internal var routeGroups: [RouteGroupKey: RouteCollectionBuilder] {
    [
      .bearer: { (bearer: RoutesBuilder) in
        bearer.post("group-sessions", use: create(from:))
      }
    ]
  }

  private func create(from request: Request) throws
    -> EventLoopFuture<CreateGroupSessionResponseContent> {
    let user = try request.auth.require(User.self)
    let userID = try user.requireID()
    let groupSession = GroupSession(userID: userID)
    return user.$groupSessions.create(groupSession, on: request.db).flatMapThrowing {
      try CreateGroupSessionResponseContent(id: groupSession.requireID())
    }
  }
}
