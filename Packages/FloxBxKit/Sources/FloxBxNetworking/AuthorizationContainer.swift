import Foundation

public protocol AuthorizationContainer {
  associatedtype AuthorizationType: Authorization
  func fetch() throws -> AuthorizationType?
}
