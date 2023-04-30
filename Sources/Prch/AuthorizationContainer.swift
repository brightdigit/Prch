import Foundation

public protocol AuthorizationContainer<AuthorizationType> {
  associatedtype AuthorizationType
  func fetch() async throws -> AuthorizationType?
}
