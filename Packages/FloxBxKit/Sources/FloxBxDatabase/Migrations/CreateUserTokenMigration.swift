import Fluent

internal struct CreateUserTokenMigration: Migration {
  var name: String {
    "FloxBxServerKit.CreateUserTokenMigration"
  }

  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(UserToken.schema)
      .id()
      .field(UserToken.FieldKeys.userID, .uuid, .required)
      .field(UserToken.FieldKeys.value, .string, .required)
      .field(UserToken.FieldKeys.expiresAt, .datetime)
      .foreignKey(
        UserToken.FieldKeys.userID,
        references: User.schema, .id,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).delete()
  }
}
