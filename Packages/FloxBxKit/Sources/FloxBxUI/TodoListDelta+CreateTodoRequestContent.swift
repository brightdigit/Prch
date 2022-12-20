import FloxBxGroupActivities
import FloxBxModels
import Foundation

extension TodoListDelta {
  public static func upsert(_ id: UUID, _ content: CreateTodoRequestContent) -> Self {
    .upsert(id, ItemContent(title: content.title, tags: content.tags))
  }
}
