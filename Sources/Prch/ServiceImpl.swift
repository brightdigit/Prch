import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class ServiceImpl<
  CoderType: Coder,
  SessionType: DefunctSession,
  RequestBuilderType: RequestBuilder,
  AuthorizationContainerType: AuthorizationContainer
>: Service, HeaderProvider where
  SessionType.SessionRequestType == RequestBuilderType.SessionRequestType,
  RequestBuilderType.SessionRequestType.DataType == CoderType.DataType,
  SessionType.SessionResponseType.DataType == CoderType.DataType {
  private let baseURLComponents: URLComponents
  public let credentialsContainer: AuthorizationContainerType
  private let coder: CoderType
  private let session: SessionType
  public let builder: RequestBuilderType
  public let headers: [String: String]

  public init(
    baseURLComponents: URLComponents,
    coder: CoderType,
    session: SessionType,
    builder: RequestBuilderType,
    credentialsContainer: AuthorizationContainerType,
    headers: [String: String]
  ) {
    self.baseURLComponents = baseURLComponents
    self.coder = coder
    self.session = session
    self.builder = builder
    self.credentialsContainer = credentialsContainer
    self.headers = headers
  }

  public func request<RequestType>(_ request: RequestType) async throws
    -> RequestType.SuccessType where RequestType: ClientRequest {
    let sessionRequest: SessionType.SessionRequestType

    let headers = try await self.headers(withCredentials: RequestType.requiresCredentials)

    sessionRequest = try builder.build(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers,
      withEncoder: coder
    )

    let data = try await session.request(sessionRequest)

    guard request.isValidStatusCode(data.statusCode) else {
      throw RequestError.invalidStatusCode(data.statusCode)
    }
    guard let bodyData = data.data else {
      throw RequestError.missingData
    }

    if let decodable = RequestType.SuccessType.decodable {
      let decoded = try coder.decode(decodable, from: bodyData)
      return try .init(decoded: decoded)
    }

    guard let value = Empty.value as? RequestType.SuccessType else {
      throw RequestError.missingData
    }

    return value
  }
}

public class GenericServiceImpl<GenericSessionType : GenericSession, CoderType : Coder> : GenericService where CoderType.DataType == GenericSessionType.GenericSessionResponseType.DataType {
  internal init(baseURLComponents: URLComponents, credentialsContainer: SimpleCredContainer, session: GenericSessionType, headers: [String : String], coder: CoderType) {
    self.baseURLComponents = baseURLComponents
    self.credentialsContainer = credentialsContainer
    self.session = session
    self.headers = headers
    self.coder = coder
  }
  

  
  private let baseURLComponents: URLComponents
  private let credentialsContainer: SimpleCredContainer
  private let session: GenericSessionType
  private let headers: [String: String]
  private let coder : CoderType
  
  private static func headers(
    withCredentials credentialsContainer: SimpleCredContainer?,
    mergedWith headers: [String: String]
  ) async throws -> [String: String] {
    let creds = try await credentialsContainer?.fetch()
    
    let authorizationHeaders: [String: String]
    if let creds = creds {
      authorizationHeaders = creds.httpHeaders
    } else {
      authorizationHeaders = [:]
    }
    
    return headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
  }
  public func request<RequestType>(_ request: RequestType) async throws -> RequestType.SuccessType where RequestType : GenericRequest {
    
    let credetials = request.requiresCredentials ? credentialsContainer : nil
    
    let headers = try await Self.headers(
      withCredentials: credetials,
      mergedWith: headers
    )
    
    let response = try await session.data(
      request: request,
      withBaseURL: baseURLComponents,
      withHeaders: headers,
      usingEncoder: self.coder
    )
    
    guard request.isValidStatusCode(response.statusCode) else {
      throw RequestError.invalidStatusCode(response.statusCode)
    }
    
    let data = response.data
    let successType = type(of: request).SuccessType
    return try self.coder.decode(successType, from: data)
  }
}
