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
}
