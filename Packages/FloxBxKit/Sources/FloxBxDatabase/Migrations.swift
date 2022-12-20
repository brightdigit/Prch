import Fluent
import Foundation

extension Migrations {
  public func configure() {
    add(CreateUserMigration())
    add(CreateTodoMigration())
    add(CreateUserTokenMigration())
    add(CreateGroupSessionMigration())
    add(CreateTagMigration())
    add(CreateTodoTagsMigration())
    add(CreateUserSubscriptionMigration())
    add(CreateMobileDeviceMigration())
    add(CreateNotificationMigration())
  }
}
