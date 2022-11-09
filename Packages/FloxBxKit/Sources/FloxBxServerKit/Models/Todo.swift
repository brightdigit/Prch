import Fluent
import Vapor

internal final class Todo: Model, Content {
  internal enum FieldKeys {
    internal static let title: FieldKey = "title"
    internal static let userID: FieldKey = "userID"
  }

  internal static let schema = "Todos"

  @ID(key: .id)
  internal var id: UUID?

  @Field(key: "title")
  internal var title: String

  @Parent(key: FieldKeys.userID)
  internal var user: User

  internal init() {}

  internal init(title: String, userID: UUID? = nil, id: UUID? = nil) {
    self.id = id
    self.title = title
    if let userID = userID {
      $user.id = userID
    }
  }
}
