import Foundation

public class Client<SessionType: Session, APIType: API> {
  public init(api: APIType, session: SessionType) {
    self.api = api
    self.session = session
  }

  public let api: APIType
  public let session: SessionType

  @discardableResult
  public func request<ResponseType>(
    _ request: Request<ResponseType, APIType>,
    _ completion: @escaping (
      RequestResponse<ResponseType>) -> Void
  ) -> Task? {
    var sessionRequest: SessionType.RequestType
    do {
      sessionRequest = try session.createRequest(
        request,
        withBaseURL: api.baseURL,
        andHeaders: api.headers,
        usingEncoder: api.encoder
      )
    } catch {
      completion(.failure(.requestEncodingError(error)))
      return nil
    }

    return session.beginRequest(sessionRequest) { result in
      let clientResult: Result<ResponseType, ClientError> =
        .init(ResponseType.self, result: result, decoder: self.api.decoder)
      completion(clientResult.response)
    }
  }
}

#if compiler(>=5.5) && canImport(_Concurrency)
  @available(iOS 13.0.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
  public extension Client {
    @available(swift 5.5)
    func request<ResponseType>(
      _ request: Request<ResponseType, APIType>
    ) async throws -> ResponseType.SuccessType {
      try await withCheckedThrowingContinuation { continuation in
        self.request(request) { response in
          let result = Result(response: response)
          continuation.resume(with: result)
        }
      }
    }
  }
#endif

public extension Client {
  func requestSync<ResponseType>(
    _ request: Request<ResponseType, APIType>
  ) throws -> ResponseType.SuccessType {
    try requestSync(request, timeout: .now() + 5.0)
  }

  func requestSync<ResponseType>(
    _ request: Request<ResponseType, APIType>,
    timeout: @autoclosure () -> DispatchTime
  ) throws -> ResponseType.SuccessType {
    var result: RequestResponse<ResponseType>!
    let semaphore = DispatchSemaphore(value: 0)
    self.request(request) {
      result = $0
      semaphore.signal()
    }

    let timeoutValue = timeout()
    let waitResult = semaphore.wait(timeout: timeoutValue)

    switch waitResult {
    case .success:
      return try result.get()

    case .timedOut:
      throw ClientError.timeout(timeoutValue)
    }
  }
}
