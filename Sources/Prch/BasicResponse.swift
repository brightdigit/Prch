import Foundation

public enum BasicResponse<
  SuccessType: Decodable & StatusCodeProvider,
  FailureType: Decodable,
  APIType: API
>: Response {
  public var decoded: ResponseDecodedType {
    switch self {
    case let .success(value):
      return .success(value)

    case let .defaultResponse(statusCode, value):
      return .failure(statusCode, value)
    }
  }

  public var response: ClientResult<SuccessType, FailureType> {
    switch self {
    case let .success(value):
      return .success(value)

    case let .defaultResponse(statusCode, value):
      return .defaultResponse(statusCode, value)
    }
  }

  public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
    switch statusCode {
    case SuccessType.statusCode:
      self = try .success(decoder.decode(SuccessType.self, from: data))

    default:
      let value = try decoder.decode(FailureType.self, from: data)
      self = .defaultResponse(statusCode, value)
    }
  }

  case success(SuccessType)
  case defaultResponse(Int, FailureType)

  var anyResponse: Any {
    switch self {
    case let .defaultResponse(_, value): return value
    case let .success(value): return value
    }
  }

  public var statusCode: Int {
    switch self {
    case let .defaultResponse(statusCode, _): return statusCode
    case .success: return SuccessType.statusCode
    }
  }

  var successful: Bool {
    switch self {
    case .defaultResponse: return false
    case .success: return true
    }
  }

  public var description: String {
    "\(statusCode) \(successful ? "success" : "failure")"
  }

  public var debugDescription: String {
    var string = description
    let responseString = "\(anyResponse)"
    if responseString != "()" {
      string += "\n\(responseString)"
    }
    return string
  }
}
