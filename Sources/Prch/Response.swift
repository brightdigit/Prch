import Foundation

public protocol Response: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  associatedtype FailureType
  associatedtype APIType: API
  var statusCode: Int { get }

  var failure: FailureType? { get }
  var anyResponse: Any { get }
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
  var success: SuccessType? { get }
}
