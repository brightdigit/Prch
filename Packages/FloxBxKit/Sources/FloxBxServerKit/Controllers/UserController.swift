import FloxBxDatabase
import FloxBxModels
import Fluent
import RouteGroups
import Vapor

internal struct UserController: RouteGroupCollection {
  internal typealias RouteGroupKeyType = RouteGroupKey

  internal var routeGroups: [RouteGroupKey: RouteCollectionBuilder] {
    [
      .publicAPI: { routes in
        routes.post("users", use: create(from:))
        routes.get("users", use: get(from:))
      }
    ]
  }

  private func create(
    from request: Request
  ) -> EventLoopFuture<CreateUserResponseContent> {
    let createUserRequestContent: CreateUserRequestContent
    let user: User
    do {
      createUserRequestContent = try request.content.decode(CreateUserRequestContent.self)
      user = User(
        email: createUserRequestContent.emailAddress,
        passwordHash: try Bcrypt.hash(createUserRequestContent.password)
      )
    } catch {
      return request.eventLoop.makeFailedFuture(error)
    }

    return user.save(on: request.db).flatMapThrowing {
      let token = try user.generateToken()
      return CreateUserResponseContent(token: token.value)
    }
  }

  private func get(
    from request: Request
  ) throws -> EventLoopFuture<GetUserResponseContent> {
    let user = try request.auth.require(User.self)
    let username = user.email
    let id = try user.requireID()
    return user.$tags.get(on: request.db).map { tags in
      GetUserResponseContent(id: id, username: username, tags: tags.compactMap { $0.id })
    }
  }
}
