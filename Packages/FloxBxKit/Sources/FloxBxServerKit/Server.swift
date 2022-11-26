import enum FloxBxModels.Configuration
import FluentPostgresDriver
import SublimationVapor
import Vapor

public struct Server {
  private let env: Environment

  public init(env: Environment) {
    self.env = env
  }

  public init() throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)
    self.init(env: env)
  }

  // configures your application
  public static func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    #if DEBUG
      if !app.environment.isRelease {
        app.lifecycle.use(
          SublimationLifecycleHandler(
            ngrokPath: "/opt/homebrew/bin/ngrok",
            bucketName: Configuration.Sublimation.bucketName,
            key: Configuration.Sublimation.key
          )
        )
      }
    #endif

    app.databases.use(.postgres(
      hostname: Environment.get("DATABASE_HOST") ?? "localhost",
      username: Environment.get("DATABASE_USERNAME") ?? "floxbx", password: ""
    ), as: .psql)

    app.migrations.add(CreateUserMigration())
    app.migrations.add(CreateTodoMigration())
    app.migrations.add(CreateUserTokenMigration())
    app.migrations.add(CreateGroupSessionMigration())

    let userController = UserController()
    let tokenController = UserTokenController()
    let api = app.routes.grouped("api", "v1")
    api.post("users", use: userController.create(from:))
    api.post("tokens", use: tokenController.create(from:))
    let bearer = api.grouped(UserToken.authenticator())
    bearer.delete("tokens", use: tokenController.delete(from:))
    bearer.get("tokens", use: tokenController.get(from:))
    bearer.get("users", use: userController.get(from:))
    try TodoController().boot(routes: bearer)
    try GroupSessionController().boot(routes: bearer)
    try app.autoMigrate().wait()
  }

  @discardableResult
  public func start() throws -> Application {
    let app = Application(env)
    defer { app.shutdown() }
    try Server.configure(app)
    try app.run()
    return app
  }
}
