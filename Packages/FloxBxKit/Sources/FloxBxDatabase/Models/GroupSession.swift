import Fluent
import Foundation

public final class GroupSession: Model {
  internal enum FieldKeys {
    internal static let userID: FieldKey = "userID"
  }

  public static let schema = "GroupSessions"

  @ID(key: .id)
  public var id: UUID?

  @Parent(key: FieldKeys.userID)
  public var user: User

  public init() {}

  public init(userID: UUID, id: UUID? = nil) {
    self.id = id
    $user.id = userID
  }
}
