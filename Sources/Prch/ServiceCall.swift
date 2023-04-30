import Foundation
import PrchModel

public protocol ServiceCall {
  associatedtype SuccessType: ContentDecodable
  associatedtype BodyType: ContentEncodable
  var path: String { get }
  var parameters: [String: String] { get }
  var method: String { get }
  var headers: [String: String] { get }
  var body: BodyType { get }
  var requiresCredentials: Bool { get }
  func isValidStatusCode(_ statusCode: Int) -> Bool
}
