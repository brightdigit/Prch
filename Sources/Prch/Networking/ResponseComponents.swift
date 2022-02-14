import Foundation

public protocol ResponseComponents {
  var statusCode: Int? { get }
  var data: Data? { get }
}
