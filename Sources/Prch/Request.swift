import Foundation

public protocol Request: CustomStringConvertible, CustomDebugStringConvertible {
  associatedtype ResponseType: Response
  typealias APIType = ResponseType.APIType
  var method: String { get }
  var path: String { get }
  var queryParameters: [String: Any] { get }
  var headers: [String: String] { get }
  var encodeBody: ((RequestEncoder) throws -> Data)? { get }
  var name: String { get }
}

public extension Request {
  var description: String {
    var string = "\(name): \(method) \(path)"
    if !queryParameters.isEmpty {
      string += "?" + queryParameters.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    return string
  }

  var debugDescription: String {
    var string = description
    if let encodeBody = encodeBody,
       let data = try? encodeBody(JSONEncoder()),
       let bodyString = String(data: data, encoding: .utf8) {
      string += "\nbody: \(bodyString)"
    }
    return string
  }
}
