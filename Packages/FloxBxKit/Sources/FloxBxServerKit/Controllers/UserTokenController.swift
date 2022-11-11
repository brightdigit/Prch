import FloxBxModels
import Fluent
import Vapor

internal struct UserTokenController: RouteCollection {
  internal func create(
    from request: Request
  ) -> EventLoopFuture<CreateTokenResponseContent> {
    let createTokenRequestContent: CreateTokenRequestContent
    do {
      createTokenRequestContent = try request.content.decode(
        CreateTokenRequestContent.self
      )
    } catch {
      return request.eventLoop.makeFailedFuture(error)
    }

    return User
      .query(on: request.db)
      .filter(\.$email == createTokenRequestContent.emailAddress)
      .first()
      .unwrap(or: Abort(.unauthorized))
      .flatMapThrowing { user -> UserToken in
        guard try user.verify(password: createTokenRequestContent.password) else {
          throw Abort(.unauthorized)
        }
        return try user.generateToken()
      }
      .flatMap { token in
        token.save(on: request.db).map {
          CreateTokenResponseContent(token: token.value)
        }
      }
  }

  internal func get(
    from request: Request
  ) -> EventLoopFuture<CreateTokenResponseContent> {
    let userToken: UserToken
    do {
      userToken = try request.auth.require(UserToken.self)
    } catch {
      return request.eventLoop.makeFailedFuture(error)
    }

    guard let timeInterval = userToken.expiresAt?.timeIntervalSinceNow else {
      return request.eventLoop.makeFailedFuture(Abort(.unauthorized))
    }

    if timeInterval < 0 {
      return request.eventLoop.makeFailedFuture(Abort(.unauthorized))
    } else if timeInterval < 60 * 60 {
      let userToken: UserToken
      do {
        userToken = try request.auth.require(User.self).generateToken()
      } catch {
        return request.eventLoop.makeFailedFuture(error)
      }

      return userToken.save(on: request.db).map {
        CreateTokenResponseContent(token: userToken.value)
      }
    } else {
      return request.eventLoop.future(CreateTokenResponseContent(token: userToken.value))
    }
  }

  internal func delete(from request: Request) -> EventLoopFuture<HTTPResponseStatus> {
    let userToken: UserToken
    do {
      userToken = try request.auth.require(UserToken.self)
    } catch {
      return request.eventLoop.makeFailedFuture(error)
    }

    return userToken.delete(on: request.db).map {
      request.auth.logout(UserToken.self)
      return .noContent
    }
  }

  internal func boot(routes: RoutesBuilder) throws {
    routes.post("tokens", use: create(from:))
    let tokenProtected = routes.grouped(UserToken.authenticator())
    tokenProtected.delete("tokens", use: delete(from:))
    tokenProtected.get("tokens", use: get(from:))
  }
}
