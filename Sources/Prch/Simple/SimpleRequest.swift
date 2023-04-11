import Foundation

struct SimpleRequest {
  let path: String
  let parameters: [String: String]
  let method: String
  let headers: [String: String]
  let body: Data?
  let requiresCredentials: Bool
}
