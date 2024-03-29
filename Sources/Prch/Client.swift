import Foundation

public class Client<SessionType: Session, APIType: API> {
  public init(api: APIType, session: SessionType) {
    self.api = api
    self.session = session
  }

  public let api: APIType
  public let session: SessionType

  @discardableResult
  public func request<RequestType: Request>(
    _ request: RequestType,
    _ completion: @escaping (
      ClientResponseResult<RequestType.ResponseType>) -> Void
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
      completion(.failure(ClientError.requestEncodingError(error)))
      return nil
    }

    return session.beginRequest(sessionRequest) { result in
      let clientResult: Result<RequestType.ResponseType, ClientError> =
        .init(RequestType.ResponseType.self, result: result, decoder: self.api.decoder)

      completion(clientResult.response)
    }
  }
}

#if compiler(>=5.5.2) && canImport(_Concurrency)
  @available(iOS 13.0.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
  public extension Client {
    @available(swift 5.5)
    func request<RequestType: Request>(
      _ request: RequestType
    ) async throws -> RequestType.ResponseType.SuccessType {
      let sessionRequest = try session.createRequest(
        request,
        withBaseURL: api.baseURL,
        andHeaders: api.headers,
        usingEncoder: api.encoder
      )

      let response = try await session.request(sessionRequest)

      guard let httpStatus = response.statusCode, let data = response.data else {
        throw ClientError.invalidResponse
      }

      return try RequestType.ResponseType(
        statusCode: httpStatus, data: data, decoder: api.decoder
      ).response.get()
    }
  }
#endif

public extension Client {
  func requestSync<RequestType: Request>(
    _ request: RequestType
  ) throws -> RequestType.ResponseType.SuccessType {
    try requestSync(request, timeout: .now() + 5.0)
  }

  func requestSync<RequestType: Request>(
    _ request: RequestType,
    timeout: @autoclosure () -> DispatchTime
  ) throws -> RequestType.ResponseType.SuccessType {
    var result: ClientResponseResult<RequestType.ResponseType>!
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
