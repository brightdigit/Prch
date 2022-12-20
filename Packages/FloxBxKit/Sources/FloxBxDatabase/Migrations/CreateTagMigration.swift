import Fluent

internal struct CreateTagMigration: Migration {
  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Tag.schema)
      .field(Tag.FieldKeys.name, .string, .identifier(auto: false))
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Todo.schema).delete()
  }
}
