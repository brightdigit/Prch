//
//  File.swift
//  
//
//  Created by Leo Dion on 5/12/21.
//

import Fluent

struct CreateUserTokenMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
      return database.schema(UserToken.schema)
            .id()
        .field(UserToken.FieldKeys.userID, .uuid, .required)
        .field(UserToken.FieldKeys.value, .string, .required)
        .field(UserToken.FieldKeys.expiresAt, .datetime)
        .foreignKey(UserToken.FieldKeys.userID, references: User.schema, .id, onDelete: .cascade, onUpdate: .cascade)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}

