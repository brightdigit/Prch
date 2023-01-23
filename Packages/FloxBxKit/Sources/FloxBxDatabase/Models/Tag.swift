import Fluent
import Foundation

public final class Tag: Model {
  internal enum FieldKeys {
    internal static let name: FieldKey = "name"
  }

  public static let schema = "Tags"

  @ID(custom: FieldKeys.name, generatedBy: .user)
  public var id: String?

  @Siblings(through: TodoTag.self, from: \.$tag, to: \.$todo)
  public var todos: [Todo]

  @Siblings(through: UserSubscription.self, from: \.$tag, to: \.$user)
  public var subscribers: [User]

  public init() {}

  public init(_ id: String? = nil) {
    self.id = id
  }
}
