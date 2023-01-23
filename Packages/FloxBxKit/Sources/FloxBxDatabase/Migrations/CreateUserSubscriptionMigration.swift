import Fluent

internal struct CreateUserSubscriptionMigration: Migration {
  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(UserSubscription.schema)
      .id()
      .field(UserSubscription.FieldKeys.userID, .uuid, .required)
      .field(UserSubscription.FieldKeys.tag, .string, .required)
      .foreignKey(
        UserSubscription.FieldKeys.tag,
        references: Tag.schema,
        Tag.FieldKeys.name,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .foreignKey(
        UserSubscription.FieldKeys.userID,
        references: User.schema, .id,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .unique(on: UserSubscription.FieldKeys.userID, UserSubscription.FieldKeys.tag)
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Todo.schema).delete()
  }
}
