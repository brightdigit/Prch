import Foundation

public extension URL {
  init<S: StringProtocol>(staticString string: S) {
    guard let url = URL(string: "\(string)") else {
      preconditionFailure("Invalid static URL string: \(string)")
    }

    self = url
  }
}
