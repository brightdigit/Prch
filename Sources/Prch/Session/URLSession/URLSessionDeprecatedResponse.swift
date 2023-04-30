import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@available(*, deprecated)
public struct URLSessionDeprecatedResponse: SessionResponse {
  public typealias DataType = Data

  private let httpURLResponse: HTTPURLResponse

  public let data: Data

  public var statusCode: Int {
    httpURLResponse.statusCode
  }

  internal init(httpURLResponse: HTTPURLResponse, data: Data) {
    self.httpURLResponse = httpURLResponse
    self.data = data
  }

  internal init?(urlResponse: URLResponse?, data: Data) {
    guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
      return nil
    }
    self.init(httpURLResponse: httpURLResponse, data: data)
  }
}

extension URLSessionDeprecatedResponse {
  internal init?(_ tuple: (Data, URLResponse)) {
    self.init(urlResponse: tuple.1, data: tuple.0)
  }
}

public struct URLSessionResponse: SessionResponse {
  public typealias DataType = Data

  internal init(httpURLResponse: HTTPURLResponse, data: Data) {
    self.httpURLResponse = httpURLResponse
    self.data = data
  }

  internal init(_ tuple: (Data, URLResponse)) throws {
    guard let response = tuple.1 as? HTTPURLResponse else {
      throw RequestError.invalidResponse(tuple.1)
    }
    self.init(httpURLResponse: response, data: tuple.0)
  }

  let httpURLResponse: HTTPURLResponse
  public let data: Data

  public var statusCode: Int {
    httpURLResponse.statusCode
  }
}
