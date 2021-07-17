import Vapor
import FluentPostgresDriver

public struct Server {
  let env : Environment
  
  public init (env: Environment) {
    self.env = env
  }
  
  public init () throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)
    self.env = env
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

    let userController = UserController()
    let tokenController = UserTokenController()
    let api = app.routes.grouped("api", "v1")
    api.post("users", use: userController.create(from:))
    api.post("tokens", use: tokenController.create(from:))
    let bearer = api.grouped(UserToken.authenticator())
    bearer.delete("tokens", use: tokenController.delete(from:))
    bearer.get("tokens", use: tokenController.get(from:))
    try TodoController().boot(routes: bearer)
      // register routes
//    try app.register(collection: TodoController())
//    try app.register(collection: UserController())
//    try app.register(collection: UserTokenController())
    
    try app.autoMigrate().wait()

  }

  @discardableResult
  public func start () throws -> Application  {
    let app = Application(env)
    defer { app.shutdown() }
    try Server.configure(app)
    try app.run()
    //try routes(app)
    return app
  }
}
