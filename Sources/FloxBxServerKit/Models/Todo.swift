import Fluent
import Vapor

final class Todo: Model, Content {
  static let schema = "Todos"
  enum FieldKeys {
    static let title: FieldKey = "title"
    static let userID: FieldKey = "userID"
  }

  @ID(key: .id)
  var id: UUID?

  @Field(key: "title")
  var title: String

  @Parent(key: FieldKeys.userID)
  var user: User

  init() {}

  init(id: UUID? = nil, title: String, userID: UUID) {
    self.id = id
    self.title = title
    $user.id = userID
  }
}
