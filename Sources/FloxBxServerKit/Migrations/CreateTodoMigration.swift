import Fluent

struct CreateTodoMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(Todo.schema)
            .id()
          .field(Todo.FieldKeys.userID, .uuid, .required)
          .field(Todo.FieldKeys.title, .string, .required)
          .foreignKey(Todo.FieldKeys.userID, references: User.schema, .id, onDelete: .cascade, onUpdate: .cascade)
              .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Todo.schema).delete()
    }
}
