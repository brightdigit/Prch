import Canary
import enum FloxBxModels.Configuration
import FluentPostgresDriver
import Vapor

public struct Server {
  let env: Environment
  let sentry: CanaryClient

  public init(env: Environment, sentry: CanaryClient = .init()) {
    self.env = env
    self.sentry = sentry
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
    // register routes
//    try app.register(collection: TodoController())
//    try app.register(collection: UserController())
//    try app.register(collection: UserTokenController())

    try app.autoMigrate().wait()
  }

  @discardableResult
  public func start() throws -> Application {
    try sentry.start(withOptions: .init(dsn: Configuration.dsn))
    let app = Application(env)
    defer { app.shutdown() }
    try Server.configure(app)
    try app.run()
    // try routes(app)
    return app
  }
}
