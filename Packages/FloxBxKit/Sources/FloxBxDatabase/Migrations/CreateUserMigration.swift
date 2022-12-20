import Fluent

internal struct CreateUserMigration: Migration {
  var name: String {
    "FloxBxServerKit.CreateUserMigration"
  }

  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema)
      .id()
      .field(User.FieldKeys.email, .string, .required)
      .field(User.FieldKeys.password, .string, .required)
      .unique(on: User.FieldKeys.email)
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).delete()
  }
}
