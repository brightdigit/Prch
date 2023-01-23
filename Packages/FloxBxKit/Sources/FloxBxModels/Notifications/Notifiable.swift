import Foundation

public protocol Notifiable: Codable {
  associatedtype PayloadType: Codable
  var title: String { get }
  var deviceToken: Data { get }
  var topic: String { get }
  var payload: PayloadType { get }
}
