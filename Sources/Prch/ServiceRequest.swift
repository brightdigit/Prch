import Foundation

public protocol ServiceRequest: Request {
  var service: Service<ResponseType> { get }
}

public extension ServiceRequest {
  var method: String {
    service.method
  }

  var path: String {
    service.path
  }

  var queryParameters: [String: Any] {
    [:]
  }

  var headers: [String: String] {
    [:]
  }

  var encodeBody: ((RequestEncoder) throws -> Data)? {
    nil
  }
}
