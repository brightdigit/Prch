import FloxBxDatabase
import FloxBxModels
import Fluent
import RouteGroups
import Vapor

internal struct TodoController: RouteGroupCollection {
  var routeGroups: [RouteGroupKey: RouteCollectionBuilder] {
    [
      .bearer: { bearer in
        let todos = bearer.grouped("todos")

        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
          todo.delete(use: delete)
          todo.put(use: update)
        }

        let sharedTodos = bearer.grouped("group-sessions", ":sessionID", "todos")
        sharedTodos.get(use: index)
        sharedTodos.post(use: create)
        sharedTodos.group(":todoID") { todo in
          todo.delete(use: delete)
          todo.put(use: update)
        }
      }
    ]
  }

  internal func index(
    from request: Request
  ) throws -> EventLoopFuture<[CreateTodoResponseContent]> {
    let user = try request.auth.require(User.self)

    let userF = GroupSession.user(fromRequest: request, otherwise: user)

    return userF.flatMap { user in
      user.$items.query(on: request.db).with(\.$tags).all()
    }
    .flatMapEachThrowing(CreateTodoResponseContent.init(todoItemWithLoadedTags:))
  }

  internal func create(
    from request: Request
  ) async throws -> CreateTodoResponseContent {
    let authUser = try request.auth.require(User.self)
    let content = try request.content.decode(CreateTodoRequestContent.self)
    let todo = Todo(title: content.title)
    async let user = try await GroupSession.user(fromRequest: request, otherwise: authUser)
    async let tags = Tag.findOrCreate(tagValues: content.tags, on: request.db)
    try await user.$items.create(todo, on: request.db)
    try await todo.$tags.attach(tags, on: request.db)
    return try await CreateTodoResponseContent(todoItem: todo, tags: tags)
  }

  internal func update(
    from request: Request
  ) async throws -> CreateTodoResponseContent {
    let authUser = try request.auth.require(User.self)
    let todoID: UUID = try request.parameters.require("todoID", as: UUID.self)
    let content = try request.content.decode(CreateTodoRequestContent.self)
    let user = try await GroupSession.user(fromRequest: request, otherwise: authUser)

    let todo = try await user.$items.query(on: request.db).filter(\.$id == todoID).first().unwrap(orError: Abort(.notFound)).get()
    async let tags = Tag.findOrCreate(tagValues: content.tags, on: request.db)

    try await todo.$tags.detachAll(on: request.db).get()
    todo.title = content.title
    try await todo.update(on: request.db)
    try await todo.$tags.attach(tags, on: request.db)

    return try await CreateTodoResponseContent(todoItem: todo, tags: tags)
  }

  internal func delete(from request: Request) async throws -> HTTPStatus {
    let authUser = try request.auth.require(User.self)
    let todoID: UUID = try request.parameters.require("todoID", as: UUID.self)
    let user = try await GroupSession.user(fromRequest: request, otherwise: authUser)

    let items = try await user.$items.query(on: request.db)
      .filter(\.$id == todoID)
      .all()

    try await items.delete(on: request.db)

    return .noContent
  }
}
