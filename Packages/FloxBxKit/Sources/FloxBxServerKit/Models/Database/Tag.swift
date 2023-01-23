import FloxBxDatabase
import FloxBxModels
import FluentKit

extension Tag {
  internal static func findOrCreate(
    tagValues: [String],
    on database: Database
  ) async throws -> [Tag] {
    try await withThrowingTaskGroup(of: Tag.self, body: { taskGroup in
      tagValues.forEach { value in
        taskGroup.addTask {
          if let tag = try await Tag.find(value, on: database) {
            return tag
          } else {
            let newTag = Tag(value)
            try await newTag.create(on: database)
            return newTag
          }
        }
      }
      return try await taskGroup.reduce(into: [Tag]()) { result, tag in
        result.append(tag)
      }
    })
  }

  internal static func find(
    tagValues: [String],
    on database: Database
  ) async throws -> [Tag] {
    try await withThrowingTaskGroup(of: Tag?.self, body: { taskGroup in
      tagValues.forEach { value in
        taskGroup.addTask {
          try await Tag.find(value, on: database)
        }
      }
      return try await taskGroup.reduce(into: [Tag]()) { result, tag in
        if let tag = tag {
          result.append(tag)
        }
      }
    })
  }
}
