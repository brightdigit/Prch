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

@available(*, deprecated, renamed: "Request")
open class DeprecatedRequest<
  ResponseType: Response, APIType
>: Request where ResponseType.APIType == APIType {
  public let service: Service<ResponseType>
  open private(set) var queryParameters: [String: Any]
  open private(set) var formParameters: [String: Any]
  public let encodeBody: ((RequestEncoder) throws -> Data)?
  private(set) var headerParameters: [String: String]
  public var customHeaders: [String: String] = [:]

  public var headers: [String: String] {
    headerParameters.merging(customHeaders) { _, custom in custom }
  }

  open var path: String {
    service.path
  }

  open var method: String {
    service.method
  }

  public init(service: Service<ResponseType>,
              queryParameters: [String: Any] = [:],
              formParameters: [String: Any] = [:],
              headers: [String: String] = [:],
              encodeBody: ((RequestEncoder) throws -> Data)? = nil) {
    self.service = service
    self.queryParameters = queryParameters
    self.formParameters = formParameters
    headerParameters = headers
    self.encodeBody = encodeBody
  }
}

extension DeprecatedRequest: CustomStringConvertible {
  public var description: String {
    var string = "\(service.name): \(service.method) \(path)"
    if !queryParameters.isEmpty {
      string += "?" + queryParameters.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    return string
  }
}

extension DeprecatedRequest: CustomDebugStringConvertible {
  public var debugDescription: String {
    var string = description
    if let encodeBody = encodeBody,
       let data = try? encodeBody(JSONEncoder()),
       let bodyString = String(data: data, encoding: .utf8) {
      string += "\nbody: \(bodyString)"
    }
    return string
  }
}
