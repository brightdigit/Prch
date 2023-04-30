import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol DeprecatedSessionResponse {
  var statusCode: Int { get }
  var data: Data { get }
}

public class GenericServiceImpl<GenericSessionType: Session>: GenericService {
  public init(
    baseURLComponents: URLComponents,
    credentialsContainer: any AuthorizationContainer<
      GenericSessionType.AuthorizationType
    >,
    session: GenericSessionType,
    headers: [String: String] = [:],
    coder: any Coder<GenericSessionType.GenericSessionResponseType.DataType>
  ) {
    self.baseURLComponents = baseURLComponents
    self.credentialsContainer = credentialsContainer
    self.session = session
    self.headers = headers
    self.coder = coder
  }

  private let baseURLComponents: URLComponents
  private let credentialsContainer:
    any AuthorizationContainer<GenericSessionType.AuthorizationType>
  private let session: GenericSessionType
  private let headers: [String: String]
  private let coder: any Coder<GenericSessionType.GenericSessionResponseType.DataType>

  public func request<RequestType>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType.DecodableType
    where RequestType: GenericRequest {
    let response = try await session.data(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers,
      authorization: credentialsContainer.fetch(),
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
