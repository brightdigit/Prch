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
