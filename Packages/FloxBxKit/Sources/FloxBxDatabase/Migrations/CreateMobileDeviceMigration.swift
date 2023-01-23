import Fluent

internal struct CreateMobileDeviceMigration: Migration {
  internal func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(MobileDevice.schema)
      .id()
      .field(MobileDevice.FieldKeys.userID, .uuid, .required)
      .field(MobileDevice.FieldKeys.model, .string, .required)
      .field(MobileDevice.FieldKeys.operatingSystem, .string, .required)
      .field(MobileDevice.FieldKeys.topic, .string, .required)
      .field(MobileDevice.FieldKeys.deviceToken, .data, .required)
      .foreignKey(
        MobileDevice.FieldKeys.userID,
        references: User.schema, .id,
        onDelete: .cascade,
        onUpdate: .cascade
      )
      .unique(on: MobileDevice.FieldKeys.deviceToken)
      .create()
  }

  internal func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Todo.schema).delete()
  }
}
