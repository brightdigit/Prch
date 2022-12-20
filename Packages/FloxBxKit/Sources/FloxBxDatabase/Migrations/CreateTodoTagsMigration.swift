import Fluent

internal struct CreateTodoTagsMigration: Migration {
  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(TodoTag.schema)
      .id()
      .field(TodoTag.FieldKeys.todoID, .uuid, .required)
      .field(TodoTag.FieldKeys.tag, .string, .required)
      .foreignKey(
        TodoTag.FieldKeys.tag,
        references: Tag.schema,
        Tag.FieldKeys.name,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .foreignKey(
        TodoTag.FieldKeys.todoID,
        references: Todo.schema, .id,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .unique(on: TodoTag.FieldKeys.todoID, TodoTag.FieldKeys.tag)
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Todo.schema).delete()
  }
}
