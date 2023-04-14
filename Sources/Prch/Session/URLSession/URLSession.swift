import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession: Session {
  public typealias SessionRequestType = URLRequest

  public typealias SessionResponseType = URLSessionResponse
  public func request(
    _ request: URLRequest,
    _ completed: @escaping (Result<URLSessionResponse, Error>) -> Void
  ) -> SessionTask {
    let task = dataTask(with: request) { data, response, error in
      let result: Result<URLSessionResponse, Error>
      if let error = error {
        result = .failure(error)
      } else if let sessionResponse = URLSessionResponse(
        urlResponse: response, data: data
      ) {
        result = .success(sessionResponse)
      } else {
        result = .failure(RequestError.invalidResponse(response))
      }
      completed(result)
    }
    task.resume()
    return task
  }

  public func request(_ request: URLRequest) async throws -> URLSessionResponse {
    let tuple = try await data(for: request)
    guard let response = URLSessionResponse(tuple) else {
      throw RequestError.invalidResponse(tuple.1)
    }
    return response
  }
}

#if canImport(FoundationNetworking)
  extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
      try await withCheckedThrowingContinuation { continuation in
        let task = self.dataTask(with: request) { data, response, error in
          let result: Result<(Data, URLResponse), Error>

          switch (data, response, error) {
          case let (_, _, .some(error)):
            result = .failure(error)

          case let (.some(data), .some(response), .none):
            result = .success((data, response))

          default:
            assertionFailure("Invalid response")
            result = .failure(RequestError.invalidResponse(nil))
          }

          continuation.resume(with: result)
        }
        task.resume()
      }
    }
  }
#endif
