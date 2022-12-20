import Foundation
extension StringProtocol {
  public func slugified(
    separator: String = "-",
    allowedCharacters: NSCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
  ) -> String {
    lowercased()
      .components(separatedBy: allowedCharacters.inverted)
      .filter { $0 != "" }
      .joined(separator: separator)
  }
}
