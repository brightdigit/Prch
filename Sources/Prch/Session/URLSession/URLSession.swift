import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession: Session {
  public typealias GenericSessionResponseType = URLSessionResponse
  public typealias GenericSessionRequestType = URLRequest

  public func data<RequestType>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    usingEncoder encoder: any Coder<Data>
  ) async throws -> URLSessionResponse
    where RequestType: GenericRequest {
    var componenents = baseURLComponents
    componenents.path = "/\(request.path)"
    componenents.queryItems = request.parameters.map(URLQueryItem.init)

    guard let url = componenents.url else {
      preconditionFailure()
    }

    var urlRequest = URLRequest(url: url)

    urlRequest.httpMethod = request.method

    #warning("Add Credential Headers")
    let allHeaders = headers.merging(
      request.headers,
      uniquingKeysWith: { lhs, _ in lhs }
    )

    for (field, value) in allHeaders {
      urlRequest.addValue(value, forHTTPHeaderField: field)
    }

    if case let .encodable(value) = request.body.encodable {
      urlRequest.httpBody = try encoder.encode(value)
    }

    #if canImport(FoundationNetworking)
      return try await withCheckedThrowingContinuation { continuation in
        self.dataTask(with: urlRequest) { data, response, error in
          let result = Result<URLSessionResponse?, Error>(catching: {
            try URLSessionResponse(error: error, data: data, urlResponse: response)
          }).flatMap { response in
            guard let response = response else {
              return .failure(RequestError.missingData)
            }
            return .success(response)
          }
          continuation.resume(with: result)
        }
      }
    #else
      let tuple: (Data, URLResponse) = try await data(for: urlRequest)
      return try URLSessionResponse(tuple)
    #endif
  }
}
