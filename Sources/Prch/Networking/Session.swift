import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Session {
  associatedtype RequestType
  func createRequest<RequestType: Request>(
    _ request: RequestType,
    withBaseURL baseURL: URL,
    andHeaders headers: [String: String],
    usingEncoder encoder: RequestEncoder
  ) throws -> Self.RequestType
  @discardableResult func beginRequest(
    _ request: RequestType,
    _ completion: @escaping ((Result<ResponseComponents, ClientError>) -> Void)
  ) -> Task
}
