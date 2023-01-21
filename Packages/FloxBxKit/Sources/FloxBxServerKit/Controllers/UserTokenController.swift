import FloxBxDatabase
import FloxBxModels
import Fluent
import RouteGroups
import Vapor

internal struct UserTokenController: RouteGroupCollection {
  internal typealias RouteGroupKeyType = RouteGroupKey

  internal var routeGroups: [RouteGroupKey: RouteCollectionBuilder] {
    [
      .bearer: { bearer in
        bearer.get("tokens", use: self.get(from:))
        bearer.delete("tokens", use: self.delete(from:))
      },
      .publicAPI: { api in
        api.post("tokens", use: self.create(from:))
      }
    ]
  }

  private func create(
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

  private func get(
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

  private func delete(from request: Request) -> EventLoopFuture<HTTPResponseStatus> {
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
}
