import Foundation

public class APIClient<SessionType: Session, APIType: API> {
  public init(api: APIType, session: SessionType) {
    self.api = api
    self.session = session
  }

  public let api: APIType
  public let session: SessionType

  @discardableResult
  public func request<ResponseType>(
    _ request: APIRequest<ResponseType, APIType>,
    _ completion: @escaping (APIResult<ResponseType>) -> Void
  ) -> Task? {
    var sessionRequest: SessionType.RequestType
    do {
      sessionRequest = try session.createRequest(
        request,
        withBaseURL: api.baseURL,
        andHeaders: api.headers,
        usingEncoder: api.encoder
      )
    } catch {
      completion(.failure(.requestEncodingError(error)))
      return nil
    }

    return session.beginRequest(sessionRequest) { result in
      completion(.init(ResponseType.self, result: result, decoder: self.api.decoder))
    }
  }
}
