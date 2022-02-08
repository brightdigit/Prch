import Foundation

public enum ResponseResult<SuccessType, DefaultResponseType>: CustomStringConvertible,
  CustomDebugStringConvertible {
  case success(SuccessType)
  case defaultResponse(Int, DefaultResponseType)
  case failure(ClientError)

  var value: Any {
    switch self {
    case let .success(value): return value
    case let .defaultResponse(_, value): return value
    case let .failure(value): return value
    }
  }

  var successful: Bool {
    switch self {
    case .success: return true
    case .defaultResponse: return false
    case .failure: return false
    }
  }

  public var description: String {
    "\(successful ? "success" : "failure")"
  }

  public var debugDescription: String {
    "\(description):\n\(value)"
  }
}

public typealias RequestResponse<ResponseType>
  = ResponseResult<ResponseType.SuccessType, ResponseType.FailureType>
  where ResponseType: Response

public extension ResponseResult {
  struct FailedResponseError: Error {
    public let statusCode: Int
    public let response: DefaultResponseType
  }

  func get() throws -> SuccessType {
    switch self {
    case let .success(value):
      return value

    case let .failure(error):
      throw error

    case let .defaultResponse(statusCode, response):
      throw FailedResponseError(statusCode: statusCode, response: response)
    }
  }
}
