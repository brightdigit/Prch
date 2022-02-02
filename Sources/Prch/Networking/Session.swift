import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol Session {
  associatedtype RequestType
  func createRequest<ResponseType: APIResponseValue, APIType: API>(
    _ request: APIRequest<ResponseType, APIType>,
    withBaseURL baseURL: URL,
    andHeaders headers: [String: String],
    usingEncoder encoder: RequestEncoder
  ) throws -> RequestType
  @discardableResult func beginRequest(
    _ request: RequestType,
    _ completion: @escaping ((APIResult<Response>) -> Void)
  ) -> Task
}
