// import Foundation
// import PrchModel
//
// #if canImport(FoundationNetworking)
//  import FoundationNetworking
// #endif
//
// @available(*, deprecated)
// public protocol RequestBuilder {
//  associatedtype SessionRequestType: SessionRequest
//
//  func build<BodyRequestType: ClientRequest, CoderType: Coder>(
//    request: BodyRequestType,
//    withBaseURL baseURLComponents: URLComponents,
//    withHeaders headers: [String: String],
//    withEncoder encoder: CoderType
//  ) throws -> SessionRequestType
//    where CoderType.DataType == SessionRequestType.DataType,
//    BodyRequestType.BodyType: ContentEncodable
//
//  func headers<AuthorizationType: Authorization>(
//    basedOnCredentials credentials: AuthorizationType
//  ) -> [String: String]
// }
