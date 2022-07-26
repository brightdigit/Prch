public protocol ClientBaseRequest {
  static var requiresCredentials: Bool { get }
  var path: String { get }
  var parameters: [String: String] { get }
  var method: RequestMethod { get }
  var headers: [String: String] { get }
}
