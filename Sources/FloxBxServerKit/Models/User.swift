import Fluent
import Vapor

final class User: Model {
  static let schema = "Users"
  enum FieldKeys {
    static var email: FieldKey { "email" }
    static var password: FieldKey { "passwordHash" }
  }

  @ID() var id: UUID?
  @Field(key: FieldKeys.email) var email: String
  @Field(key: FieldKeys.password) var passwordHash: String
  @Children(for: \Todo.$user) var items: [Todo]
  @Children(for: \GroupSession.$user) var groupSessions: [GroupSession]

  init() {}

  init(id: User.IDValue? = nil,
       email: String,
       passwordHash: String) {
    self.id = id
    self.email = email
    self.passwordHash = passwordHash
  }
}

extension User: ModelAuthenticatable {
  static var usernameKey: KeyPath<User, Field<String>> = \.$email

  static let passwordHashKey: KeyPath<User, Field<String>> = \.$passwordHash

  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: passwordHash)
  }
}

extension User {
  func generateToken() throws -> UserToken {
    try .init(
      value: [UInt8].random(count: 16).base64,
      userID: requireID()
    )
  }
}
