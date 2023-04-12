import Foundation

protocol GenericSession {
  associatedtype GenericSessionRequestType
  func build<RequestType: GenericRequest>(
    request: RequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String]
  ) throws -> GenericSessionRequestType

  func data(for request: GenericSessionRequestType) async throws -> GenericSessionResponse
}
