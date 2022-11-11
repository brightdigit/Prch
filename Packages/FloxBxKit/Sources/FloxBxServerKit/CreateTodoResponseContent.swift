import FloxBxModels

extension CreateTodoResponseContent {
  internal init(todoItem: Todo) throws {
    try self.init(id: todoItem.requireID(), title: todoItem.title)
  }
}
