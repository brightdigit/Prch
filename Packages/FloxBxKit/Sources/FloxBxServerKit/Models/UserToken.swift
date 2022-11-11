import Fluent
import Vapor

internal final class UserToken: Model, Content {
  internal enum FieldKeys {
    internal static let userID: FieldKey = "userID"
    internal static let value: FieldKey = "value"
    internal static let expiresAt: FieldKey = "expiresAt"
  }

  internal static let schema = "UserTokens"

  @ID(key: .id)
  internal var id: UUID?

  @Field(key: FieldKeys.value)
  internal var value: String

  @Parent(key: FieldKeys.userID)
  internal var user: User

  /// Expiration date. Token will no longer be valid after this point.
  @Timestamp(key: "expiresAt", on: .delete)
  internal var expiresAt: Date?

  internal init() {}

  internal init(
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

extension UserToken: ModelTokenAuthenticatable {
  internal static let valueKey: KeyPath<UserToken, Field<String>> = \.$value
  internal static let userKey: KeyPath<UserToken, Parent<User>> = \.$user

  internal var isValid: Bool {
    guard let expiresAt = expiresAt else {
      return false
    }
    return expiresAt > Date()
  }
}
