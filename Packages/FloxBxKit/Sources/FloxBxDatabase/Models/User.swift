import Fluent
import Foundation

public final class User: Model {
  internal enum FieldKeys {
    internal static var email: FieldKey { "email" }
    internal static var password: FieldKey { "passwordHash" }
  }

  public static let schema = "Users"

  @ID() public var id: UUID?
  @Field(key: FieldKeys.email) public var email: String
  @Field(key: FieldKeys.password) public var passwordHash: String
  @Children(for: \Todo.$user) public var items: [Todo]
  @Children(for: \GroupSession.$user) public var groupSessions: [GroupSession]
  @Children(for: \MobileDevice.$user) public var mobileDevices: [MobileDevice]
  @Siblings(through: UserSubscription.self, from: \.$user, to: \.$tag)
  public var tags: [Tag]

  public init() {}

  public init(
    email: String,
    passwordHash: String,

    id: User.IDValue? = nil
  ) {
    self.id = id
    self.email = email
    self.passwordHash = passwordHash
  }
}
