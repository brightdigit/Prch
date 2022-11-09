import Fluent
import Vapor

internal final class GroupSession: Model, Content {
  internal enum FieldKeys {
    internal static let userID: FieldKey = "userID"
  }

  internal static let schema = "GroupSessions"

  @ID(key: .id)
  internal var id: UUID?

  @Parent(key: FieldKeys.userID)
  internal var user: User

  internal init() {}

  internal init(userID: UUID, id: UUID? = nil) {
    self.id = id
    $user.id = userID
  }
}

extension GroupSession {
  internal static func user(
    forGroupSessionWithID groupSessionID: UUID?,
    otherwise user: User,
    on database: Database,
    eventLoop: EventLoop
  ) -> EventLoopFuture<User> {
    let userF: EventLoopFuture<User>
    if let sessionID: UUID = groupSessionID {
      let session = GroupSession.find(
        sessionID, on: database
      )
      .unwrap(orError: Abort(.notFound))
      userF = session.flatMap {
        $0.$user.get(on: database)
      }
    } else {
      userF = eventLoop.makeSucceededFuture(user)
    }
    return userF
  }

  internal static func user(
    fromRequest request: Request,
    otherwise user: User
  ) -> EventLoopFuture<User> {
    let sessionID = request.parameters.get("sessionID", as: UUID.self)
    let database = request.db
    let eventLoop = request.eventLoop
    return self.user(
      forGroupSessionWithID: sessionID,
      otherwise: user,
      on: database,
      eventLoop: eventLoop
    )
  }
}
