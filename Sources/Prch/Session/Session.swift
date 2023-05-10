import Foundation
import PrchModel

public protocol Session{
  associatedtype RequestDataType
  associatedtype ResponseType: SessionResponse
  associatedtype AuthorizationType

  func data<RequestType: ServiceCall>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    authorizationManager: any AuthorizationManager<AuthorizationType>,
    usingEncoder encoder: any Encoder<RequestDataType>
  ) async throws -> ResponseType
}
