import FelinePine
import FloxBxLogging
import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public class ServiceImpl<
  CoderType: Coder,
  SessionType: Session,
  RequestBuilderType: RequestBuilder,
  AuthorizationContainerType: AuthorizationContainer
>: Service, HeaderProvider, LoggerCategorized where
  SessionType.SessionRequestType == RequestBuilderType.SessionRequestType,
  RequestBuilderType.SessionRequestType.DataType == CoderType.DataType,
  SessionType.SessionResponseType.DataType == CoderType.DataType {
  public typealias LoggersType = FloxBxLogging.Loggers

  public static var loggingCategory: FloxBxLogging.LoggerCategory {
    .networking
  }

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
      Self.logger.error("Error building request: \(error.localizedDescription)")
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
      Self.logger.error("Error building request: \(error.localizedDescription)")
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

      sessionRequest = try builder.build(
        request: request,
        withBaseURL: baseURLComponents,
        withHeaders: headers,
        withEncoder: coder
      )
    } catch {
      Self.logger.error("Error building request: \(error.localizedDescription)")
      completed(.failure(error))
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
      Self.logger.error("Error building request: \(error.localizedDescription)")
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
}
