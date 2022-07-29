import FloxBxGroupActivities
import FloxBxModels
import Foundation

public extension TodoListDelta {
  static func upsert(_ id: UUID, _ content: CreateTodoRequestContent) -> Self {
    .upsert(id, ItemContent(title: content.title))
  }
}
