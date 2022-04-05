import FloxBxKit
import Fluent
import Vapor

extension CreateTodoRequestContent: Content {}
extension CreateTodoResponseContent: Content {}

extension CreateTodoResponseContent {
  init(todoItem: Todo) throws {
    try self.init(id: todoItem.requireID(), title: todoItem.title)
  }
}

struct TodoController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let todos = routes.grouped("todos")
    todos.get(use: index)
    todos.post(use: create)
    todos.group(":todoID") { todo in
      todo.delete(use: delete)
      todo.put(use: update)
    }
  }

  func index(from request: Request) throws -> EventLoopFuture<[CreateTodoResponseContent]> {
    let user = try request.auth.require(User.self)
    return user.$items.get(on: request.db).flatMapEachThrowing(CreateTodoResponseContent.init(todoItem:))
  }

  func create(from request: Request) throws -> EventLoopFuture<CreateTodoResponseContent> {
    let user = try request.auth.require(User.self)
    let userID = try user.requireID()
    let content = try request.content.decode(CreateTodoRequestContent.self)
    let todo = Todo(title: content.title, userID: userID)
    return user.$items.create(todo, on: request.db).flatMapThrowing {
      try CreateTodoResponseContent(id: todo.requireID(), title: todo.title)
    }
  }

  func update(from request: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
    let user = try request.auth.require(User.self)
    let todoID: UUID = try request.parameters.require("todoID", as: UUID.self)
    let content = try request.content.decode(CreateTodoRequestContent.self)
    return user.$items.query(on: request.db)
      .filter(\.$id == todoID)
      .first().unwrap(orError: Abort(.notFound))
      .flatMap { todo -> EventLoopFuture<Void> in
        todo.title = content.title
        return todo.update(on: request.db)
      }.transform(to: .noContent)
  }

  func delete(from request: Request) throws -> EventLoopFuture<HTTPStatus> {
    let user = try request.auth.require(User.self)
    let todoID: UUID = try request.parameters.require("todoID", as: UUID.self)
    return user.$items.query(on: request.db).filter(\.$id == todoID).all()
      .flatMap { $0.delete(on: request.db) }
      .transform(to: .noContent)
  }
}
