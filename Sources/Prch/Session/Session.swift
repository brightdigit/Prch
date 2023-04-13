public protocol Session {
  associatedtype SessionRequestType: SessionRequest
  associatedtype SessionResponseType: SessionResponse
  @discardableResult
  func request(
    _ request: SessionRequestType,
    _ completed: @escaping (Result<SessionResponseType, Error>) -> Void
  ) -> SessionTask
  
  
  func request (_ request: SessionRequestType) async throws -> SessionResponseType
}


extension Session {
  public func request (_ request: SessionRequestType) async throws -> SessionResponseType {
    try await withCheckedThrowingContinuation{ continuation in
      self.request(request, continuation.resume(with:))
    }
  }
}
