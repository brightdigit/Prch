import FloxBxModels
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

    let sharedTodos = routes.grouped("group-sessions", ":sessionID", "todos")
    sharedTodos.get(use: index)
    sharedTodos.post(use: create)
    sharedTodos.group(":todoID") { todo in
      todo.delete(use: delete)
      todo.put(use: update)
    }
  }

  func index(from request: Request) throws -> EventLoopFuture<[CreateTodoResponseContent]> {
    let user = try request.auth.require(User.self)

    let userF: EventLoopFuture<User> = GroupSession.user(fromRequest: request, otherwise: user)
    return userF.flatMap { user in
      user.$items.get(on: request.db)
    }.flatMapEachThrowing(CreateTodoResponseContent.init(todoItem:))
  }

  func create(from request: Request) throws -> EventLoopFuture<CreateTodoResponseContent> {
    let user = try request.auth.require(User.self)
    let content = try request.content.decode(CreateTodoRequestContent.self)
    let todo = Todo(title: content.title)

    let userF: EventLoopFuture<User> = GroupSession.user(fromRequest: request, otherwise: user)

    return userF.flatMap { user in
      user.$items.create(todo, on: request.db).flatMapThrowing {
        try CreateTodoResponseContent(id: todo.requireID(), title: todo.title)
      }
    }
  }

  func update(from request: Request) throws -> EventLoopFuture<CreateTodoResponseContent> {
    let user = try request.auth.require(User.self)
    let todoID: UUID = try request.parameters.require("todoID", as: UUID.self)
    let content = try request.content.decode(CreateTodoRequestContent.self)
    let userF: EventLoopFuture<User> = GroupSession.user(fromRequest: request, otherwise: user)

    return userF.flatMap { user in
      user.$items.query(on: request.db)
        .filter(\.$id == todoID)
        .first().unwrap(orError: Abort(.notFound))
        .flatMap { todo -> EventLoopFuture<Void> in
          todo.title = content.title
          return todo.update(on: request.db)
        }.transform(to: CreateTodoResponseContent(id: todoID, title: content.title))
    }
  }

  func delete(from request: Request) throws -> EventLoopFuture<HTTPStatus> {
    let user = try request.auth.require(User.self)
    let todoID: UUID = try request.parameters.require("todoID", as: UUID.self)
    let userF: EventLoopFuture<User> = GroupSession.user(fromRequest: request, otherwise: user)
    return userF.flatMap { user in
      user.$items.query(on: request.db).filter(\.$id == todoID).all()
        .flatMap { $0.delete(on: request.db) }
        .transform(to: .noContent)
    }
  }
}
