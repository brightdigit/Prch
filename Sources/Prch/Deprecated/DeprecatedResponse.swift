import Foundation

@available(*, deprecated, message: "Use DecodedResponse.")
public protocol DeprecatedResponse: Response {
  var success: SuccessType? { get }

  var failure: FailureType? { get }
}

public extension DeprecatedResponse {
  var decoded: ResponseResult<SuccessType, FailureType> {
    if let successValue = success {
      return .success(successValue)
    } else if let failureValue = failure {
      return .defaultResponse(statusCode, failureValue)
    } else {
      preconditionFailure()
    }
  }

  var response: ClientResult<SuccessType, FailureType> {
    decoded.response
  }
}

public extension DeprecatedResponse where FailureType == Never {
  var failure: FailureType? {
    nil
  }
}
