import Foundation

extension URL {
  public init(staticString string: StaticString) {
    guard let url = URL(string: "\(string)") else {
      preconditionFailure("Invalid static URL string: \(string)")
    }

    self = url
  }

  public init(components: URLComponents) {
    guard let url = components.url else {
      preconditionFailure("Invalid static URL components: \(components)")
    }

    self = url
  }
}
