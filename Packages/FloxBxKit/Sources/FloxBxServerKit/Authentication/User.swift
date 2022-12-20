import FloxBxDatabase
import Fluent
import Vapor

extension User: ModelAuthenticatable {
  public static var usernameKey: KeyPath<User, Field<String>> = \.$email

  public static let passwordHashKey: KeyPath<User, Field<String>> = \.$passwordHash

  public func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: passwordHash)
  }
}

extension User {
  public func generateToken() throws -> UserToken {
    try .init(
      value: [UInt8].random(count: 16).base64,
      userID: requireID()
    )
  }
}
