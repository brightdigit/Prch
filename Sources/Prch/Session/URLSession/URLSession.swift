import Foundation
import PrchModel

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

    let tuple: (Data, URLResponse) = try await data(for: urlRequest)
    return try URLSessionResponse(tuple)
  }
}
