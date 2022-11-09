import Fluent
import Vapor

internal final class User: Model {
  internal enum FieldKeys {
    internal static var email: FieldKey { "email" }
    internal static var password: FieldKey { "passwordHash" }
  }

  internal static let schema = "Users"

  @ID() internal var id: UUID?
  @Field(key: FieldKeys.email) internal var email: String
  @Field(key: FieldKeys.password) internal var passwordHash: String
  @Children(for: \Todo.$user) internal var items: [Todo]
  @Children(for: \GroupSession.$user) internal var groupSessions: [GroupSession]

  internal init() {}

  internal init(
    email: String,
    passwordHash: String,

    id: User.IDValue? = nil
  ) {
    self.id = id
    self.email = email
    self.passwordHash = passwordHash
  }
}

extension User: ModelAuthenticatable {
  internal static var usernameKey: KeyPath<User, Field<String>> = \.$email

  internal static let passwordHashKey: KeyPath<User, Field<String>> = \.$passwordHash

  internal func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: passwordHash)
  }
}

extension User {
  internal func generateToken() throws -> UserToken {
    try .init(
      value: [UInt8].random(count: 16).base64,
      userID: requireID()
    )
  }
}
