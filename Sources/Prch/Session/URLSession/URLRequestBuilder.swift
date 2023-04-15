import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@available(*, deprecated)
public struct URLRequestBuilder: RequestBuilder {
  public func build<BodyRequestType, CoderType>(
    request: BodyRequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    withEncoder encoder: CoderType
  ) throws -> URLRequest where BodyRequestType: ClientRequest,
    CoderType: Coder, CoderType.DataType == Data {
    var componenents = baseURLComponents
    componenents.path = "/\(request.path)"
    componenents.queryItems = request.parameters.map(URLQueryItem.init)

    guard let url = componenents.url else {
      preconditionFailure()
    }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue

    let allHeaders = headers.merging(request.headers, uniquingKeysWith: { lhs, _ in lhs })
    for (field, value) in allHeaders {
      urlRequest.addValue(value, forHTTPHeaderField: field)
    }

    if case let .encodable(value) = request.body.encodable {
      urlRequest.httpBody = try encoder.encode(value)
    }

    return urlRequest
  }

  public typealias SessionRequestType = URLRequest
  public init() {}

  public func headers<AuthorizationType>(
    basedOnCredentials credentials: AuthorizationType
  ) -> [String: String] where AuthorizationType: Authorization {
    credentials.httpHeaders
  }
}
