import Foundation

public protocol Model: Codable, Equatable {}

extension Model {
  func encode() -> [String: Any] {
    guard
      let jsonData = try? JSONEncoder().encode(self),
      let jsonValue = try? JSONSerialization.jsonObject(with: jsonData),
      let jsonDictionary = jsonValue as? [String: Any] else {
      return [:]
    }
    return jsonDictionary
  }
}
