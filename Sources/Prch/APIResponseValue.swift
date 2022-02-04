import Foundation

public protocol APIResponseValue: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  associatedtype FailureType
  associatedtype APIType: API
  var statusCode: Int { get }

  // var successful: Bool { get }
  var failure: FailureType? { get }
  var anyResponse: Any { get }
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
  var success: SuccessType? { get }
}

public extension APIResponseValue {
  var result: APIResponseResult<SuccessType, FailureType> {
    if let successValue = success {
      return .success(successValue)
    } else if let failureValue = failure {
      return .failure(failureValue)
    } else {
      fatalError("Response does not have success or failure response")
    }
  }
}
