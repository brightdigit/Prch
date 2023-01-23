import FloxBxDatabase
import Fluent
import Foundation

extension UserToken: ModelTokenAuthenticatable {
  public static let valueKey: KeyPath<UserToken, Field<String>> = \.$value
  public static let userKey: KeyPath<UserToken, Parent<User>> = \.$user

  public var isValid: Bool {
    guard let expiresAt = expiresAt else {
      return false
    }
    return expiresAt > Date()
  }
}
