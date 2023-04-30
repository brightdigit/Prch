import Foundation
import PrchModel

@available(*, deprecated)
public protocol DefunctSession {
  associatedtype SessionRequestType: SessionRequest
  associatedtype SessionResponseType: SessionResponse

  func request(_ request: SessionRequestType) async throws -> SessionResponseType
}

public protocol Session<GenericSessionRequestType> {
  associatedtype GenericSessionRequestType
  associatedtype GenericSessionResponseType: SessionResponse
  associatedtype AuthorizationType

  func data<RequestType: GenericRequest>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    authorization: AuthorizationType?,
    usingEncoder encoder: any Coder<GenericSessionResponseType.DataType>
  ) async throws -> GenericSessionResponseType
}
