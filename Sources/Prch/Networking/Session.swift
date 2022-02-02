import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Session {
  associatedtype RequestType
  func createRequest<ResponseType: Response, APIType: API>(
    _ request: Request<ResponseType, APIType>,
    withBaseURL baseURL: URL,
    andHeaders headers: [String: String],
    usingEncoder encoder: RequestEncoder
  ) throws -> RequestType
  @discardableResult func beginRequest(
    _ request: RequestType,
    _ completion: @escaping ((Result<ResponseComponents, ClientError>) -> Void)
  ) -> Task
}
