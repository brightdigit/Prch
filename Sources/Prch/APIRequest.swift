import Foundation

open class APIRequest<
  ResponseType: APIResponseValue, APIType
> where ResponseType.APIType == APIType {
  public let service: APIService<ResponseType>
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

  public init(service: APIService<ResponseType>,
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

extension APIRequest: CustomStringConvertible {
  public var description: String {
    var string = "\(service.name): \(service.method) \(path)"
    if !queryParameters.isEmpty {
      string += "?" + queryParameters.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    return string
  }
}

extension APIRequest: CustomDebugStringConvertible {
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
