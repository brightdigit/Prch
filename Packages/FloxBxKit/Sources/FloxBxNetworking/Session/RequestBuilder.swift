import Foundation
import FloxBxModeling

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol RequestBuilder {
  associatedtype SessionRequestType: SessionRequest
  
  @available(*, deprecated)
  func build<BodyRequestType: LegacyClientRequest, CoderType: LegacyCoder>(
    request: BodyRequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    withEncoder encoder: CoderType
  ) throws -> SessionRequestType
    where CoderType.DataType == SessionRequestType.DataType,
    BodyRequestType.BodyType: Encodable

  @available(*, deprecated)
  func build<BodyRequestType: LegacyClientRequest, CoderType: LegacyCoder>(
    request: BodyRequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    withEncoder encoder: CoderType
  ) throws -> SessionRequestType
    where CoderType.DataType == SessionRequestType.DataType,
    BodyRequestType.BodyType == Void
  
  func build<BodyRequestType: ClientRequest, CoderType: Coder>(
    request: BodyRequestType,
    withBaseURL baseURLComponents: URLComponents,
    withHeaders headers: [String: String],
    withEncoder encoder: CoderType
  ) throws -> SessionRequestType
  where CoderType.DataType == SessionRequestType.DataType, BodyRequestType.BodyType: ContentEncodable

  func headers<AuthorizationType: Authorization>(
    basedOnCredentials credentials: AuthorizationType
  ) -> [String: String]
}
