import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class Service<SessionType: Session>: ServiceProtocol {
  public init(
    baseURLComponents: URLComponents,
    fetchAuthorization: @escaping () async throws -> SessionType.AuthorizationType?,
    session: SessionType,
    headers: [String: String] = [:],
    coder: any Coder<SessionType.ResponseType.DataType>
  ) {
    self.baseURLComponents = baseURLComponents
    self.fetchAuthorization = fetchAuthorization
    self.session = session
    self.headers = headers
    self.coder = coder
  }

  private let baseURLComponents: URLComponents
  private let fetchAuthorization: () async throws -> SessionType.AuthorizationType?
  private let session: SessionType
  private let headers: [String: String]
  private let coder: any Coder<SessionType.ResponseType.DataType>

  public func request<RequestType>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType.DecodableType
    where RequestType: ServiceCall {
    let response = try await session.data(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers,
      authorization: fetchAuthorization(),
      usingEncoder: coder
    )

    guard request.isValidStatusCode(response.statusCode) else {
      throw RequestError.invalidStatusCode(response.statusCode)
    }

    return try coder.decodeContent(
      RequestType.SuccessType.self,
      from: response.data
    )
  }
}
