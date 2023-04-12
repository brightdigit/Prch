import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

class GenericService {
  internal init(baseURLComponents: URLComponents, credentialsContainer: SimpleCredContainer, session: URLSession, headers: [String: String]) {
    self.baseURLComponents = baseURLComponents
    self.credentialsContainer = credentialsContainer
    self.session = session
    self.headers = headers
  }

  private let baseURLComponents: URLComponents
  private let credentialsContainer: SimpleCredContainer
  private let session: URLSession
  private let headers: [String: String]

  private static func headers(
    withCredentials credentialsContainer: SimpleCredContainer?,
    mergedWith headers: [String: String]
  ) async throws -> [String: String] {
    let creds = try await credentialsContainer?.fetch()

    let authorizationHeaders: [String: String]
    if let creds = creds {
      authorizationHeaders = creds.httpHeaders
    } else {
      authorizationHeaders = [:]
    }

    return headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
  }

  private func build<RequestType: GenericRequest>(request: RequestType,
                                                  withBaseURL baseURLComponents: URLComponents,
                                                  withHeaders headers: [String: String]) throws -> URLRequest {
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

  func request<SuccessType: Decodable>(
    _ request: some GenericRequest
  ) async throws -> some Decodable {
    let sessionRequest: URLRequest
    let credetials = request.requiresCredentials ? credentialsContainer : nil

    let headers = try await Self.headers(
      withCredentials: credetials,
      mergedWith: headers
    )

    sessionRequest = try build(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers
    )

    let (data, response) = try await session.data(for: sessionRequest)

    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1

    guard statusCode / 100 == 2 else {
      throw RequestError.invalidStatusCode(statusCode)
    }

    let decoder = JSONDecoder()
    let successType = type(of: request).SuccessType
    return try decoder.decode(successType, from: data)
  }
}
