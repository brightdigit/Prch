import Foundation

public protocol Session {
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
  func build<RequestType : GenericRequest>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String : String]
  ) throws -> GenericSessionRequestType
  
  func data(for request: GenericSessionRequestType) async throws -> GenericSessionResponse
}
