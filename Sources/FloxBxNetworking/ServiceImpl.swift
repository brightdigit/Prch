import Foundation
import FloxBxAuth
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class ServiceImpl<CoderType: Coder, SessionType: Session, RequestBuilderType: RequestBuilder>: Service where SessionType.SessionRequestType == RequestBuilderType.SessionRequestType, RequestBuilderType.SessionRequestType.DataType == CoderType.DataType, SessionType.SessionResponseType.DataType == CoderType.DataType {
  public func beginRequest<RequestType>(_ request: RequestType, _ completed: @escaping (Result<RequestType.SuccessType, Error>) -> Void) where RequestType: ClientRequest, RequestType.BodyType: Encodable, RequestType.SuccessType: Decodable {
    let sessionRequest: SessionType.SessionRequestType
    let creds: Credentials?
    do {
      creds = try credentialsContainer.fetch()
    } catch {
      completed(.failure(error))
      return
    }
    let authorizationHeaders: [String: String]
    if let creds = creds, RequestType.requiresCredentials {
      authorizationHeaders = builder.headers(basedOnCredentials: creds)
    } else {
      authorizationHeaders = [:]
    }

    let headers = self.headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
    do {
      sessionRequest = try builder.build(request: request, withBaseURL: baseURLComponents, withHeaders: headers, withEncoder: coder)
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      let decodedResult: Result<RequestType.SuccessType, Error> = result.flatMap { data in
        guard let bodyData = data.data else {
          return Result<RequestType.SuccessType, Error>.failure(RequestError.missingData)
        }

        return Result {
          try self.coder.decode(RequestType.SuccessType.self, from: bodyData)
        }
      }
      dump(decodedResult)
      completed(decodedResult)
    }
  }

  public func beginRequest<RequestType>(_ request: RequestType, _ completed: @escaping (Error?) -> Void) where RequestType: ClientRequest, RequestType.BodyType: Encodable, RequestType.SuccessType == Void {
    let sessionRequest: SessionType.SessionRequestType
    let creds: Credentials?
    do {
      creds = try credentialsContainer.fetch()
    } catch {
      completed(error)
      return
    }
    let authorizationHeaders: [String: String]
    if let creds = creds, RequestType.requiresCredentials {
      authorizationHeaders = builder.headers(basedOnCredentials: creds)
    } else {
      authorizationHeaders = [:]
    }

    let headers = self.headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
    do {
      sessionRequest = try builder.build(request: request, withBaseURL: baseURLComponents, withHeaders: headers, withEncoder: coder)
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      completed(result.asVoid().asError())
    }
  }

  public func beginRequest<RequestType>(_ request: RequestType, _ completed: @escaping (Result<RequestType.SuccessType, Error>) -> Void) where RequestType: ClientRequest, RequestType.BodyType == Void, RequestType.SuccessType: Decodable {
    let sessionRequest: SessionType.SessionRequestType
    let creds: Credentials?
    do {
      creds = try credentialsContainer.fetch()
    } catch {
      completed(.failure(error))
      return
    }
    let authorizationHeaders: [String: String]
    if let creds = creds, RequestType.requiresCredentials {
      authorizationHeaders = builder.headers(basedOnCredentials: creds)
    } else {
      authorizationHeaders = [:]
    }

    let headers = self.headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
    do {
      sessionRequest = try builder.build(request: request, withBaseURL: baseURLComponents, withHeaders: headers, withEncoder: coder)
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      let decodedResult: Result<RequestType.SuccessType, Error> = result.flatMap { data in
        guard let bodyData = data.data else {
          return Result<RequestType.SuccessType, Error>.failure(RequestError.missingData)
        }

        return Result {
          try self.coder.decode(RequestType.SuccessType.self, from: bodyData)
        }
      }
      completed(decodedResult)
    }
  }

  public func beginRequest<RequestType>(_ request: RequestType, _ completed: @escaping (Error?) -> Void) where RequestType: ClientRequest, RequestType.BodyType == Void, RequestType.SuccessType == Void {
    let sessionRequest: SessionType.SessionRequestType
    let creds: Credentials?
    do {
      creds = try credentialsContainer.fetch()
    } catch {
      completed(error)
      return
    }
    let authorizationHeaders: [String: String]
    if let creds = creds, RequestType.requiresCredentials {
      authorizationHeaders = builder.headers(basedOnCredentials: creds)
    } else {
      authorizationHeaders = [:]
    }

    let headers = self.headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
    do {
      sessionRequest = try builder.build(request: request, withBaseURL: baseURLComponents, withHeaders: headers, withEncoder: coder)
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      completed(result.asVoid().asError())
    }
  }

  var baseURLComponents: URLComponents
  let credentialsContainer = CredentialsContainer(accessGroup:  "MLT7M394S7.com.brightdigit.FloxBx", serviceName: "floxbx.work")
  let coder: CoderType
  let session: SessionType
  let builder: RequestBuilderType

  let headers: [String: String]

  internal init(baseURLComponents: URLComponents, coder: CoderType, session: SessionType, builder: RequestBuilderType, headers: [String: String]) {
    self.baseURLComponents = baseURLComponents
    self.coder = coder
    self.session = session
    self.builder = builder
    self.headers = headers
  }

  public func save(credentials: Credentials) throws {
    try credentialsContainer.save(credentials: credentials)
  }

  public func fetchCredentials() throws -> Credentials? {
    try credentialsContainer.fetch()
  }
}

public extension ServiceImpl {
  convenience init(host: String, coder: JSONCoder = .init(encoder: JSONEncoder(), decoder: JSONDecoder()), session: URLSession = .shared, headers: [String: String]) where RequestBuilderType == URLRequestBuilder, SessionType == URLSession, CoderType == JSONCoder {
    var baseURLComponents = URLComponents()
    baseURLComponents.host = host
    baseURLComponents.scheme = "https"
    self.init(baseURLComponents: baseURLComponents, coder: coder, session: session, builder: .init(), headers: headers)
  }
}
