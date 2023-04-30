import Foundation
import PrchModel

public protocol Session<RequestType> {
  associatedtype RequestType
  associatedtype ResponseType: SessionResponse
  associatedtype AuthorizationType

  func data<RequestType: ServiceCall>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    authorization: AuthorizationType?,
    usingEncoder encoder: any Coder<ResponseType.DataType>
  ) async throws -> ResponseType
}
