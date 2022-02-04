import Foundation

public enum APIResponseResult<SuccessType, FailureType>: CustomStringConvertible,
  CustomDebugStringConvertible {
  case success(SuccessType)
  case failure(FailureType)

  public var value: Any {
    switch self {
    case let .success(value): return value
    case let .failure(value): return value
    }
  }

  public var successful: Bool {
    switch self {
    case .success: return true
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
