import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct URLSessionResponse: SessionResponse {
  public typealias DataType = Data

  private let httpURLResponse: HTTPURLResponse

  public let data: Data?

  public var statusCode: Int {
    httpURLResponse.statusCode
  }

  internal init?(urlResponse: URLResponse?, data: Data?) {
    guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
      return nil
    }
    print("status code:", httpURLResponse.statusCode)
    self.httpURLResponse = httpURLResponse
    self.data = data
  }
}
