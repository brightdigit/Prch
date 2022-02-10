import Foundation

public enum ResponseDecoded<SuccessType, FailureType> {
  case success(SuccessType)
  case failure(Int, FailureType)
}

public protocol DecodedResponse: Response
  where SuccessType: Decodable, FailureType: Decodable {
  static var successCode: Int { get }
  init(fromDecoded decoded: ResponseDecodedType)
}

public extension DecodedResponse {
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
    let decoded: ResponseDecodedType
    switch statusCode {
    case Self.successCode:
      decoded = try .success(decoder.decode(SuccessType.self, from: data))

    default:
      let value = try decoder.decode(FailureType.self, from: data)
      decoded = .failure(statusCode, value)
    }
    self.init(fromDecoded: decoded)
  }

  var statusCode: Int {
    switch decoded {
    case .success: return Self.successCode
    case let .failure(statusCode, _): return statusCode
    }
  }

  internal var successful: Bool {
    switch decoded {
    case .failure: return false
    case .success: return true
    }
  }

  internal var anyResponse: Any {
    switch decoded {
    case let .failure(_, value): return value
    case let .success(value): return value
    }
  }

  var description: String {
    "\(statusCode) \(successful ? "success" : "failure")"
  }

  var debugDescription: String {
    var string = description
    let responseString = "\(anyResponse)"
    if responseString != "()" {
      string += "\n\(responseString)"
    }
    return string
  }
}

public protocol Response: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  associatedtype FailureType
  associatedtype APIType: API
  var statusCode: Int { get }

  var decoded: ResponseDecodedType { get }
  typealias ResponseDecodedType = ResponseDecoded<SuccessType, FailureType>
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
}
