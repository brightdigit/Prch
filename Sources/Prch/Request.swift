import Foundation

public protocol Request {
  associatedtype ResponseType: Response
  typealias APIType = ResponseType.APIType
  var method: String { get }
  var path: String { get }
  var queryParameters: [String: Any] { get }
  var headers: [String: String] { get }
  var encodeBody: ((RequestEncoder) throws -> Data)? { get }
}
