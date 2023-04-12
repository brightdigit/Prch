import Foundation

protocol GenericRequest {
  var path: String { get }
  var parameters: [String: String] { get }
  var method: String { get }
  var headers: [String: String] { get }
  var body: Data? { get }
  var requiresCredentials: Bool { get }
}
