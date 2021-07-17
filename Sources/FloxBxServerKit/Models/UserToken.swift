import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "UserTokens"
  
  
  struct FieldKeys {
      static let userID: FieldKey = "userID"
      static let value: FieldKey = "value"
    static let expiresAt : FieldKey = "expiresAt"
  }

    @ID(key: .id)
    var id: UUID?

  @Field(key: FieldKeys.value)
    var value: String

  @Parent(key: FieldKeys.userID)
    var user: User
  
  /// Expiration date. Token will no longer be valid after this point.
   @Timestamp(key: "expiresAt", on: .delete)
   var expiresAt: Date?


    init() { }

  init(id: UUID? = nil, value: String, userID: User.IDValue , expiresAt: Date = Date(timeInterval: 60 * 60 * 5, since: .init())) {
        self.id = id
        self.value = value
        self.$user.id = userID
    self.expiresAt = expiresAt
    }
}


extension UserToken : ModelTokenAuthenticatable {
  static let valueKey: KeyPath<UserToken, Field<String>> = \.$value
  static let userKey: KeyPath<UserToken, Parent<User>> = \.$user
  
  var isValid: Bool {
    guard let expiresAt = self.expiresAt else {
      return false
    }
    return expiresAt > Date()
  }
  
  
}
