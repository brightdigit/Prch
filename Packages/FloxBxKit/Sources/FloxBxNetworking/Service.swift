import FloxBxAuth
import Foundation

public protocol Service {
  func save(credentials: Credentials) throws

  @discardableResult
  func resetCredentials() throws -> Credentials.ResetResult

  func fetchCredentials() throws -> Credentials?

  func beginRequest<RequestType: ClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Result<RequestType.SuccessType, Error>
    ) -> Void
  ) where
    RequestType.SuccessType: Decodable,
    RequestType.BodyType == Void

  func beginRequest<RequestType: ClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Error?) -> Void
  ) where
    RequestType.SuccessType == Void,
    RequestType.BodyType == Void

  func beginRequest<RequestType: ClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Result<RequestType.SuccessType, Error>) -> Void
  ) where
    RequestType.SuccessType: Decodable,
    RequestType.BodyType: Encodable

  func beginRequest<RequestType: ClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Error?) -> Void
  ) where
    RequestType.SuccessType == Void,
    RequestType.BodyType: Encodable
}

extension CheckedContinuation where T == Void {
  public func resume(with error: E?) {
    if let error = error {
      return resume(throwing: error)
    } else {
      return resume()
    }
  }
}

extension Service {
  public func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
    where RequestType.SuccessType: Decodable, RequestType.BodyType: Encodable {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { result in
        continuation.resume(with: result)
      }
    }
  }

  public func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
    where RequestType.SuccessType: Decodable, RequestType.BodyType == Void {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { result in
        continuation.resume(with: result)
      }
    }
  }

  public func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws
    where RequestType.SuccessType == Void, RequestType.BodyType: Encodable {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { error in
        continuation.resume(with: error)
      }
    }
  }

  public func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws
    where RequestType.SuccessType == Void, RequestType.BodyType == Void {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { error in
        continuation.resume(with: error)
      }
    }
  }
}
