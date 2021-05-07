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
          port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
          username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
          password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
          database: Environment.get("DATABASE_NAME") ?? "vapor_database"
      ), as: .psql)

      app.migrations.add(CreateTodo())

      // register routes
    try app.register(collection: TodoController())

  }

  @discardableResult
  public func start () throws -> Application  {
    let app = Application(env)
    defer { app.shutdown() }
    try Server.configure(app)
    try app.run()
    try routes(app)
    return app
  }
}
