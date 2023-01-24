import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct URLRequestBuilder: RequestBuilder {
  public typealias SessionRequestType = URLRequest
  public init() {}
  public func build<BodyRequestType, CoderType>(
    request: BodyRequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    withEncoder _: CoderType
  ) throws -> URLRequest
    where BodyRequestType: ClientRequest,
    CoderType: Coder,
    BodyRequestType.BodyType == Void,
    CoderType.DataType == Data {
    var componenents = baseURLComponents
    componenents.path = request.actualPath
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

    return urlRequest
  }

  public func build<BodyRequestType, CoderType>(
    request: BodyRequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    withEncoder encoder: CoderType
  ) throws -> URLRequest
    where BodyRequestType: ClientRequest,
    CoderType: Coder,
    BodyRequestType.BodyType: Encodable,
    CoderType.DataType == Data {
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

    urlRequest.httpBody = try encoder.encode(request.body)

    return urlRequest
  }

  public func headers<AuthorizationType>(
    basedOnCredentials credentials: AuthorizationType
  ) -> [String: String] where AuthorizationType: Authorization {
    credentials.httpHeaders
  }
}
