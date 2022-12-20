import Fluent

internal struct CreateGroupSessionMigration: Migration {
  var name: String {
    "FloxBxServerKit.CreateGroupSessionMigration"
  }

  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(GroupSession.schema)
      .id()
      .field(GroupSession.FieldKeys.userID, .uuid, .required)
      .foreignKey(
        GroupSession.FieldKeys.userID,
        references: User.schema, .id,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(GroupSession.schema).delete()
  }
}
