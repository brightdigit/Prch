import FloxBxAuth
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class ServiceImpl<
  CoderType: Coder,
  SessionType: Session,
  RequestBuilderType: RequestBuilder
>: Service, HeaderProvider where
  SessionType.SessionRequestType == RequestBuilderType.SessionRequestType,
  RequestBuilderType.SessionRequestType.DataType == CoderType.DataType,
  SessionType.SessionResponseType.DataType == CoderType.DataType {
  private let baseURLComponents: URLComponents
  public let credentialsContainer: CredentialsContainer
  private let coder: CoderType
  private let session: SessionType
  public let builder: RequestBuilderType
  public let headers: [String: String]

  internal init(
    baseURLComponents: URLComponents,
    coder: CoderType,
    session: SessionType,
    builder: RequestBuilderType,
    credentialsContainer: CredentialsContainer,
    headers: [String: String]
  ) {
    self.baseURLComponents = baseURLComponents
    self.coder = coder
    self.session = session
    self.builder = builder
    self.credentialsContainer = credentialsContainer
    self.headers = headers
  }

  public func beginRequest<RequestType>(
    _ request: RequestType,
    _ completed: @escaping (Result<RequestType.SuccessType, Error>) -> Void
  ) where RequestType: ClientRequest,
    RequestType.BodyType: Encodable,
    RequestType.SuccessType: Decodable {
    let sessionRequest: SessionType.SessionRequestType

    let headers: [String: String]
    do {
      headers = try self.headers(withCredentials: RequestType.requiresCredentials)
    } catch {
      completed(.failure(error))
      return
    }

    do {
      sessionRequest = try builder.build(
        request: request,
        withBaseURL: baseURLComponents,
        withHeaders: headers,
        withEncoder: coder
      )
    } catch {
      return
    }

    session.request(sessionRequest) { result in
      let decodedResult: Result<RequestType.SuccessType, Error> = result.flatMap { data in
        guard request.isValidStatusCode(data.statusCode) else {
          return Result.failure(RequestError.invalidStatusCode(data.statusCode))
        }
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

  public func beginRequest<RequestType>(
    _ request: RequestType,
    _ completed: @escaping (Error?) -> Void
  ) where RequestType: ClientRequest,
    RequestType.BodyType: Encodable,
    RequestType.SuccessType == Void {
    let sessionRequest: SessionType.SessionRequestType

    let headers: [String: String]
    do {
      headers = try self.headers(withCredentials: RequestType.requiresCredentials)
    } catch {
      completed(error)
      return
    }

    do {
      sessionRequest = try builder.build(
        request: request,
        withBaseURL: baseURLComponents,
        withHeaders: headers,
        withEncoder: coder
      )
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      let error = result.flatMap { response -> Result<Void, Error> in
        guard request.isValidStatusCode(response.statusCode) else {
          return .failure(RequestError.invalidStatusCode(response.statusCode))
        }
        return .success(())
      }
      .asError()
      completed(error)
    }
  }

  public func beginRequest<RequestType>(
    _ request: RequestType,
    _ completed: @escaping (Result<RequestType.SuccessType, Error>) -> Void
  ) where
    RequestType: ClientRequest,
    RequestType.BodyType == Void,
    RequestType.SuccessType: Decodable {
    let sessionRequest: SessionType.SessionRequestType
    let headers: [String: String]
    do {
      headers = try self.headers(withCredentials: RequestType.requiresCredentials)
    } catch {
      completed(.failure(error))
      return
    }
    do {
      sessionRequest = try builder.build(
        request: request,
        withBaseURL: baseURLComponents,
        withHeaders: headers,
        withEncoder: coder
      )
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      let decodedResult: Result<RequestType.SuccessType, Error> = result.flatMap { data in
        guard request.isValidStatusCode(data.statusCode) else {
          return Result<RequestType.SuccessType, Error>
            .failure(RequestError.invalidStatusCode(data.statusCode))
        }
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

  public func beginRequest<RequestType>(
    _ request: RequestType,
    _ completed: @escaping (Error?) -> Void
  ) where
    RequestType: ClientRequest,
    RequestType.BodyType == Void,
    RequestType.SuccessType == Void {
    let sessionRequest: SessionType.SessionRequestType
    let headers: [String: String]
    do {
      headers = try self.headers(withCredentials: RequestType.requiresCredentials)
    } catch {
      completed(error)
      return
    }
    do {
      sessionRequest = try builder.build(
        request: request,
        withBaseURL: baseURLComponents,
        withHeaders: headers,
        withEncoder: coder
      )
    } catch {
      return
    }
    session.request(sessionRequest) { result in
      let error = result.flatMap { response -> Result<Void, Error> in
        guard request.isValidStatusCode(response.statusCode) else {
          return .failure(RequestError.invalidStatusCode(response.statusCode))
        }
        return .success(())
      }
      .asError()
      completed(error)
    }
  }

  public func save(credentials: Credentials) throws {
    try credentialsContainer.save(credentials: credentials)
  }

  public func resetCredentials() throws -> Credentials.ResetResult {
    try credentialsContainer.reset()
  }

  public func fetchCredentials() throws -> Credentials? {
    try credentialsContainer.fetch()
  }
}

#if canImport(Security)
  extension ServiceImpl {
    public convenience init(
      baseURL: URL,
      accessGroup: String,
      serviceName: String,
      headers: [String: String] = ["Content-Type": "application/json; charset=utf-8"],
      coder: JSONCoder = .init(encoder: JSONEncoder(), decoder: JSONDecoder()),
      session: URLSession = .shared
    ) where
      RequestBuilderType == URLRequestBuilder,
      SessionType == URLSession,
      CoderType == JSONCoder {
      guard let baseURLComponents = URLComponents(
        url: baseURL,
        resolvingAgainstBaseURL: false
      ) else {
        preconditionFailure("Invalid baseURL: \(baseURL)")
      }
      self.init(
        baseURLComponents: baseURLComponents,
        coder: coder,
        session: session,
        builder: .init(),
        credentialsContainer:
        KeychainContainer(
          accessGroup: accessGroup,
          serviceName: serviceName
        ),
        headers: headers
      )
    }
  }
#endif
