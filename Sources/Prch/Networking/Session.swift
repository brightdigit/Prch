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

  #if compiler(>=5.5) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    func request(
      _ request: RequestType
    ) async throws -> ResponseComponents
  #endif
}
