import Fluent

struct CreateGroupSessionMigration: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(GroupSession.schema)
      .id()
      .field(GroupSession.FieldKeys.userID, .uuid, .required)
      .foreignKey(GroupSession.FieldKeys.userID, references: User.schema, .id, onDelete: .cascade, onUpdate: .cascade)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(GroupSession.schema).delete()
  }
}
