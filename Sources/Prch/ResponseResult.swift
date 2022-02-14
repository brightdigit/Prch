import Foundation

public enum ResponseResult<SuccessType, FailureType> {
  case success(SuccessType)
  case defaultResponse(Int, FailureType)
}

extension ResponseResult {
  var response: ClientResult<SuccessType, FailureType> {
    switch self {
    case let .success(value):
      return .success(value)

    case let .defaultResponse(statusCode, value):
      return .defaultResponse(statusCode, value)
    }
  }
}
