public protocol Session {
  associatedtype SessionRequestType: SessionRequest
  associatedtype SessionResponseType: SessionResponse
  @discardableResult
  func request(_ request: SessionRequestType, _ completed: @escaping (Result<SessionResponseType, Error>) -> Void) -> SessionTask
}
