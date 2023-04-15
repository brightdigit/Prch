import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession: Session {
  public typealias SessionRequestType = URLRequest

  public typealias SessionResponseType = URLSessionResponse
  
  @available(*, deprecated)
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
    let tuple : (Data, URLResponse) = try await self.data(for: request)
    guard let response = URLSessionResponse(tuple) else {
      throw RequestError.invalidResponse(tuple.1)
    }
    return response
  }
}


extension URLSession : GenericSession {

  
  public typealias GenericSessionRequestType = URLRequest
  
  public func build<RequestType>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String : String]
  ) throws -> URLRequest
  where RequestType : GenericRequest {
        var componenents = baseURLComponents
        componenents.path = "/\(request.path)"
        componenents.queryItems = request.parameters.map(URLQueryItem.init)
    
        guard let url = componenents.url else {
          preconditionFailure()
        }
    
        var urlRequest = URLRequest(url: url)
    
        urlRequest.httpMethod = request.method
    
        let allHeaders = headers.merging(request.headers, uniquingKeysWith: { lhs, _ in lhs })
    
        for (field, value) in allHeaders {
          urlRequest.addValue(value, forHTTPHeaderField: field)
        }
    
        if let body = request.body {
          urlRequest.httpBody = body
        }
    
        return urlRequest
  }
  
  public func data(for request: GenericSessionRequestType) async throws -> GenericSessionResponse {
    let tuple : (Data, URLResponse) = try await self.data(for: request)
    return try URLGenericSessionResponse(tuple)
    
  }
}
