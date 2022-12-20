import Fluent

internal struct CreateTodoMigration: Migration {
  var name: String {
    "FloxBxServerKit.CreateTodoMigration"
  }

  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Todo.schema)
      .id()
      .field(Todo.FieldKeys.userID, .uuid, .required)
      .field(Todo.FieldKeys.title, .string, .required)
      .foreignKey(
        Todo.FieldKeys.userID,
        references: User.schema, .id,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Todo.schema).delete()
  }
}
