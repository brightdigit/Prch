import Foundation
import PrchModel
@available(*, deprecated)
public protocol Service {
  associatedtype AuthorizationContainerType: AuthorizationContainer

  var credentialsContainer: AuthorizationContainerType { get }

  func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
}

public protocol GenericService {
  func request<RequestType: GenericRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType.DecodableType
}
