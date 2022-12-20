import FloxBxDatabase
import FloxBxModels

extension CreateTodoResponseContent {
  internal init(todoItem: Todo, tags: [Tag]) throws {
    try self.init(id: todoItem.requireID(), title: todoItem.title, tags: tags.compactMap { $0.id })
  }

  internal init(todoItemWithLoadedTags todoItem: Todo) throws {
    try self.init(todoItem: todoItem, tags: todoItem.tags)
  }
}
