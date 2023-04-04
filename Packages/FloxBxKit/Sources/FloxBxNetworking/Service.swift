import Foundation

public protocol Service {
  associatedtype AuthorizationContainerType: AuthorizationContainer

  var credentialsContainer: AuthorizationContainerType { get }
  
  @available(*, deprecated)
  func beginRequest<RequestType: LegacyClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Result<RequestType.SuccessType, Error>
    ) -> Void
  ) where
    RequestType.SuccessType: Decodable,
    RequestType.BodyType == Void

  @available(*, deprecated)
  func beginRequest<RequestType: LegacyClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Error?) -> Void
  ) where
    RequestType.SuccessType == Void,
    RequestType.BodyType == Void

  @available(*, deprecated)
  func beginRequest<RequestType: LegacyClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Result<RequestType.SuccessType, Error>) -> Void
  ) where
    RequestType.SuccessType: Decodable,
    RequestType.BodyType: Encodable

  @available(*, deprecated)
  func beginRequest<RequestType: LegacyClientRequest>(
    _ request: RequestType,
    _ completed: @escaping (Error?) -> Void
  ) where
    RequestType.SuccessType == Void,
    RequestType.BodyType: Encodable
  
  func request<RequestType: ClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
}

extension Service {
  @available(*, deprecated)
  public func request<RequestType: LegacyClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
    where RequestType.SuccessType: Decodable, RequestType.BodyType: Encodable {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { result in
        continuation.resume(with: result)
      }
    }
  }

  @available(*, deprecated)
  public func request<RequestType: LegacyClientRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
    where RequestType.SuccessType: Decodable, RequestType.BodyType == Void {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { result in
        continuation.resume(with: result)
      }
    }
  }

  @available(*, deprecated)
  public func request<RequestType: LegacyClientRequest>(
    _ request: RequestType
  ) async throws
    where RequestType.SuccessType == Void, RequestType.BodyType: Encodable {
    try await withCheckedThrowingContinuation { continuation in
      self.beginRequest(request) { error in
        continuation.resume(with: error)
      }
    }
  }

  @available(*, deprecated)
  public func request<RequestType: LegacyClientRequest>(
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
