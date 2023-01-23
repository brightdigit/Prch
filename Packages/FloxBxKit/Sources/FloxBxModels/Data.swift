import Foundation

extension Data {
  public var deviceTokenString: String {
    map { String(format: "%02.2hhx", $0) }.joined()
  }
}
