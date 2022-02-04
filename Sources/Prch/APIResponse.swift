import Foundation

public struct APIResponse<T: APIResponseValue, APIType> where T.APIType == APIType {
  /// The APIRequest used for this response
  public let request: APIRequest<T, APIType>

  /// The result of the response .
  public let result: APIResult<T>

  /// The URL request sent to the server.
  public let urlRequest: URLRequest?

  /// The server's response to the URL request.
  public let urlResponse: HTTPURLResponse?

  /// The data returned by the server.
  public let data: Data?

  init(request: APIRequest<T, APIType>,
       result: APIResult<T>,
       urlRequest: URLRequest? = nil,
       urlResponse: HTTPURLResponse? = nil,
       data: Data? = nil) {
    self.request = request
    self.result = result
    self.urlRequest = urlRequest
    self.urlResponse = urlResponse
    self.data = data
  }
}

extension APIResponse: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    var string = "\(request)"

    switch result {
    case let .success(value):
      string += " returned \(value.statusCode)"
      let responseString = "\(type(of: value.anyResponse))"
      if responseString != "()" {
        string += ": \(responseString)"
      }
    case let .failure(error): string += " failed: \(error)"
    }
    return string
  }

  public var debugDescription: String {
    var string = description
    if let response = try? result.get().anyResponse {
      if let debugStringConvertible = response as? CustomDebugStringConvertible {
        string += "\n\(debugStringConvertible.debugDescription)"
      }
    }
    return string
  }
}
