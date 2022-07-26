import FloxBxKit
import Fluent
import Vapor

extension CreateGroupSessionResponseContent : Content {}

struct GroupSessionController : RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let group = routes.grouped("group-sessions")
    
    group.post(use: self.create(from:))
  }
  
  func create(from request: Request) throws -> EventLoopFuture<CreateGroupSessionResponseContent> {
    let user = try request.auth.require(User.self)
    let userID = try user.requireID()
    let groupSession = GroupSession(userID: userID)
    return user.$groupSessions.create(groupSession, on: request.db).flatMapThrowing {
      try CreateGroupSessionResponseContent(id: groupSession.requireID())
    }
  }
}
