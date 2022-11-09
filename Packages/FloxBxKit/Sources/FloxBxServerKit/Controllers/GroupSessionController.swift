import FloxBxModels
import Fluent
import Vapor

internal struct GroupSessionController: RouteCollection {
  internal func boot(routes: RoutesBuilder) throws {
    let group = routes.grouped("group-sessions")

    group.post(use: create(from:))
  }

  internal func create(from request: Request) throws
    -> EventLoopFuture<CreateGroupSessionResponseContent> {
    let user = try request.auth.require(User.self)
    let userID = try user.requireID()
    let groupSession = GroupSession(userID: userID)
    return user.$groupSessions.create(groupSession, on: request.db).flatMapThrowing {
      try CreateGroupSessionResponseContent(id: groupSession.requireID())
    }
  }
}
