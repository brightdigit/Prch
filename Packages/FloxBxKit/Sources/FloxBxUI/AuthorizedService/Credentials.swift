import FloxBxAuth
import FloxBxNetworking

extension Credentials: Authorization {
  public var httpHeaders: [String: String] {
    guard let token = self.token else {
      return [:]
    }
    return ["Authorization": "Bearer \(token)"]
  }
}
