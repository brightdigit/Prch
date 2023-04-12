import Foundation

class GenericServiceImpl<GenericSessionType: GenericSession>: GenericService {
  internal init(baseURLComponents: URLComponents, credentialsContainer: SimpleCredContainer, session: GenericSessionType, headers: [String: String]) {
    self.baseURLComponents = baseURLComponents
    self.credentialsContainer = credentialsContainer
    self.session = session
    self.headers = headers
  }

  private let baseURLComponents: URLComponents
  private let credentialsContainer: SimpleCredContainer
  private let session: GenericSessionType
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

  func request<RequestType>(_ request: RequestType) async throws -> RequestType.SuccessType where RequestType: GenericRequest {
    let credetials = request.requiresCredentials ? credentialsContainer : nil

    let headers = try await Self.headers(
      withCredentials: credetials,
      mergedWith: headers
    )

    let sessionRequest = try session.build(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers
    )

    let response = try await session.data(for: sessionRequest)

    guard response.statusCode / 100 == 2 else {
      throw RequestError.invalidStatusCode(response.statusCode)
    }
    let data: Data = response.data
    let decoder = JSONDecoder()
    let successType = type(of: request).SuccessType
    return try decoder.decode(successType, from: data)
  }
}
