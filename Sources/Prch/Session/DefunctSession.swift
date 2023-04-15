import Foundation
import PrchModel

@available(*, deprecated)
public protocol DefunctSession {
  associatedtype SessionRequestType: SessionRequest
  associatedtype SessionResponseType: SessionResponse
  
  @available(*, deprecated)
  @discardableResult
  func request(
    _ request: SessionRequestType,
    _ completed: @escaping (Result<SessionResponseType, Error>) -> Void
  ) -> SessionTask

  func request(_ request: SessionRequestType) async throws -> SessionResponseType
}

public protocol GenericSession<GenericSessionRequestType> {
  
  associatedtype GenericSessionRequestType
  associatedtype GenericSessionResponseType : GenericSessionResponse
  
  func data<RequestType : GenericRequest>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String : String],
    usingEncoder encoder: any Coder<GenericSessionResponseType.DataType>
  ) async throws -> GenericSessionResponseType
  
  
}
