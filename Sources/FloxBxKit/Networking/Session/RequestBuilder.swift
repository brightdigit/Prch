import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol RequestBuilder {
  associatedtype SessionRequestType: SessionRequest
  func build<BodyRequestType: ClientRequest, CoderType: Coder>(request: BodyRequestType, withBaseURL baseURLComponents: URLComponents, withHeaders headers: [String: String], withEncoder encoder: CoderType) throws -> SessionRequestType where CoderType.DataType == SessionRequestType.DataType, BodyRequestType.BodyType: Encodable

  func build<BodyRequestType: ClientRequest, CoderType: Coder>(request: BodyRequestType, withBaseURL baseURLComponents: URLComponents, withHeaders headers: [String: String], withEncoder encoder: CoderType) throws -> SessionRequestType where CoderType.DataType == SessionRequestType.DataType, BodyRequestType.BodyType == Void
  func headers(basedOnCredentials credentials: Credentials) -> [String: String]
}
