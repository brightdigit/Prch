import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct URLSessionResponse: ResponseComponents {
  init(data: Data?, response: URLResponse?) {
    self.data = data
    self.response = response
  }

  let data: Data?
  let response: URLResponse?

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
      return .success(URLSessionResponse(data: data, response: response))
    }
  }
}

extension URLSessionResponse {
  init(_ components: (Data, URLResponse)) {
    self.init(data: components.0, response: components.1)
  }
}
