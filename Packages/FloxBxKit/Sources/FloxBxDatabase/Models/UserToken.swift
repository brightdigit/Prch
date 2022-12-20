import Fluent
import Foundation

public final class UserToken: Model {
  internal enum FieldKeys {
    internal static let userID: FieldKey = "userID"
    internal static let value: FieldKey = "value"
    internal static let expiresAt: FieldKey = "expiresAt"
  }

  public static let schema = "UserTokens"

  @ID(key: .id)
  public var id: UUID?

  @Field(key: FieldKeys.value)
  public var value: String

  @Parent(key: FieldKeys.userID)
  public var user: User

  /// Expiration date. Token will no longer be valid after this point.
  @Timestamp(key: "expiresAt", on: .delete)
  public var expiresAt: Date?

  public init() {}

  public init(
    value: String,
    userID: User.IDValue,
    id: UUID? = nil,
    expiresAt: Date = Date(timeInterval: 60 * 60 * 5, since: .init())
  ) {
    self.id = id
    self.value = value
    $user.id = userID
    self.expiresAt = expiresAt
  }
}
