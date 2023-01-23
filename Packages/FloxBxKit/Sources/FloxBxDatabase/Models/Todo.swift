import Fluent
import Foundation

public final class Todo: Model {
  internal enum FieldKeys {
    internal static let title: FieldKey = "title"
    internal static let userID: FieldKey = "userID"
  }

  public static let schema = "Todos"

  @ID(key: .id)
  public var id: UUID?

  @Field(key: "title")
  public var title: String

  @Parent(key: FieldKeys.userID)
  public var user: User

  @Siblings(through: TodoTag.self, from: \.$todo, to: \.$tag)
  public var tags: [Tag]

  public init() {}

  public init(title: String, userID: UUID? = nil, id: UUID? = nil) {
    self.id = id
    self.title = title
    if let userID = userID {
      $user.id = userID
    }
  }
}
