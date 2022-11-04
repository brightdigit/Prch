import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct URLSessionResponse: SessionResponse {
  internal init?(urlResponse: URLResponse?, data: Data?) {
    guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
      return nil
    }
    self.httpURLResponse = httpURLResponse
    self.data = data
  }

  public var statusCode: Int {
    httpURLResponse.statusCode
  }

  public typealias DataType = Data

  let httpURLResponse: HTTPURLResponse

  public let data: Data?
}
