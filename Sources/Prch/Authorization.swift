import Foundation

public protocol Authorization {
  var httpHeaders: [String: String] { get }
}
