import Foundation

public protocol ResponseComponents {
  var statusCode: Int? { get }
  var data: Data? { get }
}

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct URLSessionResponse: ResponseComponents {
  let response: URLResponse?
  let data: Data?

  var statusCode: Int? {
    (response as? HTTPURLResponse)?.statusCode
  }

  static func resultBasedOnResponse(
    _ response: URLResponse?,
    data: Data?,
    error: Error?
  ) -> Result<ResponseComponents, ClientError> {
    if let error = error {
      return .failure(.networkError(error))
    } else {
      return .success(URLSessionResponse(response: response, data: data))
    }
  }
}
