import FloxBxDatabase
import FloxBxModels
import Fluent
import RouteGroups
import Vapor

internal struct GroupSessionController: RouteGroupCollection {
  typealias RouteGroupKeyType = RouteGroupKey

  internal func create(from request: Request) throws
    -> EventLoopFuture<CreateGroupSessionResponseContent> {
    let user = try request.auth.require(User.self)
    let userID = try user.requireID()
    let groupSession = GroupSession(userID: userID)
    return user.$groupSessions.create(groupSession, on: request.db).flatMapThrowing {
      try CreateGroupSessionResponseContent(id: groupSession.requireID())
    }
  }

  var routeGroups: [RouteGroupKey: RouteCollectionBuilder] {
    [
      .bearer: { (bearer: RoutesBuilder) in
        bearer.post("group-sessions", use: create(from:))
      }
    ]
  }
}
