import Fluent
import Vapor

final class GroupSession: Model, Content {
  static let schema = "GroupSessions"
  enum FieldKeys {
    static let userID: FieldKey = "userID"
  }

  @ID(key: .id)
  var id: UUID?

  @Parent(key: FieldKeys.userID)
  var user: User

  init() {}

  init(id: UUID? = nil, userID: UUID) {
    self.id = id
    $user.id = userID
  }
}

extension GroupSession {
  static func user(forGroupSessionWithID groupSessionID: UUID?, otherwise user: User, on db: Database, eventLoop: EventLoop) -> EventLoopFuture<User> {
    let userF: EventLoopFuture<User>
    if let sessionID: UUID = groupSessionID {
      let session = GroupSession.find(sessionID, on: db).unwrap(orError: Abort(.notFound))
      userF = session.flatMap {
        $0.$user.get(on: db)
      }
    } else {
      userF = eventLoop.makeSucceededFuture(user)
    }
    return userF
  }

  static func user(fromRequest request: Request, otherwise user: User) -> EventLoopFuture<User> {
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
