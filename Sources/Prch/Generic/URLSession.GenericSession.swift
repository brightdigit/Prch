import Foundation

extension URLSession: GenericSession {
  typealias GenericSessionRequestType = URLRequest

  func build<RequestType>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String]
  ) throws -> URLRequest
    where RequestType: GenericRequest {
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

  func data(for request: GenericSessionRequestType) async throws -> GenericSessionResponse {
    let tuple: (Data, URLResponse) = try await data(for: request)
    return try URLGenericSessionResponse(tuple)
  }
}
