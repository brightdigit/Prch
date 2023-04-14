import Foundation

public protocol Service {
  associatedtype AuthorizationContainerType: AuthorizationContainer

  var credentialsContainer: AuthorizationContainerType { get }

  func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
}
