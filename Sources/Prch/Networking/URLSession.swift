import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession: Session {
  #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS, deprecated: 12.0)
    @available(iOS, deprecated: 15.0)
    @available(watchOS, deprecated: 8.0)
    @available(tvOS, deprecated: 15.0)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    fileprivate func responseComponentsFrom(
      _ request: URLRequest
    ) async throws -> ResponseComponents {
      try await withCheckedThrowingContinuation { continuation in
        _ = self.beginRequest(request) { result in
          continuation.resume(with: result)
        }
      }
    }

    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func request(_ request: RequestType) async throws -> ResponseComponents {
      #if canImport(FoundationNetworking)
        return try await responseComponentsFrom(request)
      #else
        if #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) {
          let components = try await self.data(for: request)
          return URLSessionResponse(components)
        } else {
          return try await responseComponentsFrom(request)
        }
      #endif
    }
  #endif

  public func beginRequest(
    _ request: URLRequest,
    _ completion: @escaping ((Result<ResponseComponents, ClientError>) -> Void)
  ) -> Task {
    let task = dataTask(with: request) { data, response, error in
      let result = URLSessionResponse.resultBasedOnResponse(
        response,
        data: data,
        error: error
      )
      completion(result)
    }
    task.resume()
    return task
  }

  public func createRequest<RequestType: Request>(
    _ request: RequestType,
    withBaseURL baseURL: URL,
    andHeaders headers: [String: String],
    usingEncoder encoder: RequestEncoder
  ) throws -> URLRequest {
    guard var componenets = URLComponents(
      url: baseURL.appendingPathComponent(request.path),
      resolvingAgainstBaseURL: false
    ) else {
      throw ClientError.badURL(baseURL, request.path)
    }

    // filter out parameters with empty string value
    var queryItems = [URLQueryItem]()
    for (key, value) in request.queryParameters {
      if !String(describing: value).isEmpty {
        queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
      }
    }
    componenets.queryItems = queryItems

    guard let url = componenets.url else {
      throw ClientError.urlComponents(componenets)
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method

    urlRequest.allHTTPHeaderFields = request.headers.merging(
      headers,
      uniquingKeysWith: { requestHeaderKey, _ in
        requestHeaderKey
      }
    )

    if let encodeBody = request.encodeBody {
      urlRequest.httpBody = try encodeBody(encoder)
    }
    return urlRequest
  }
}
