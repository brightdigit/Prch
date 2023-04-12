import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession: Session {
  public typealias ResponseType = URLSession.Response
  public typealias RequestType = URLRequest

  public func data<RequestType>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    authorization: URLSessionAuthorization?,
    usingEncoder encoder: any Coder<Data>
  ) async throws -> URLSession.Response
    where RequestType: ServiceCall {
    var componenents = baseURLComponents
    componenents.path = "/\(request.path)"
    componenents.queryItems = request.parameters.map(URLQueryItem.init)

    guard let url = componenents.url else {
      preconditionFailure()
    }

    var urlRequest = URLRequest(url: url)

    urlRequest.httpMethod = request.method

    let authHeaders = (request.requiresCredentials ?
      authorization?.httpHeaders : [:]
    ) ?? [:]

    let allHeaders = headers.merging(
      request.headers,
      uniquingKeysWith: { lhs, _ in lhs }
    ).merging(authHeaders) { _, rhs in
      rhs
    }

    for (field, value) in allHeaders {
      urlRequest.addValue(value, forHTTPHeaderField: field)
    }

    if case let .encodable(value) = request.body.encodable {
      urlRequest.httpBody = try encoder.encode(value)
    }

    #if canImport(FoundationNetworking)
      return try await withCheckedThrowingContinuation { continuation in
        _ = self.dataTask(with: urlRequest) { data, response, error in
          let result: Result<Response, Error> =
            Result<Response?, Error>(catching: {
              try Response(error: error, data: data, urlResponse: response)
            }).flatMap { response in
              guard let response = response else {
                return .failure(RequestError.missingData)
              }
              return .success(response)
            }
          continuation.resume(with: result)
        }
      }
      completed(result)
    }
    task.resume()
    return task
  }
  
  
  public func request(_ request: URLRequest) async throws -> URLSessionResponse {
    let tuple = try await self.data(for: request)
    guard let response = URLSessionResponse(tuple) else {
      throw RequestError.invalidResponse(tuple.1)
    }
    return response
  }
}
