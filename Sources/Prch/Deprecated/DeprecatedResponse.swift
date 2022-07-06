import Foundation

@available(*, deprecated, message: "Use DecodedResponse.")
public protocol DeprecatedResponse: Response {
  var success: SuccessType? { get }

  var failure: FailureType? { get }
}
