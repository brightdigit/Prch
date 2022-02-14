import Foundation

public protocol StatusCodeProvider {
  static var statusCode: Int { get }
}
