import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public typealias CodableAny = AnyCodable

public protocol APIResponseValue: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  var statusCode: Int { get }
  var successful: Bool { get }
  var response: Any { get }
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
  var success: SuccessType? { get }
}

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

public struct APIResponse<T: APIResponseValue> {
  /// The APIRequest used for this response
  public let request: APIRequest<T>

  /// The result of the response .
  public let result: APIResult<T>

  /// The URL request sent to the server.
  public let urlRequest: URLRequest?

  /// The server's response to the URL request.
  public let urlResponse: HTTPURLResponse?

  /// The data returned by the server.
  public let data: Data?

  init(request: APIRequest<T>,
       result: APIResult<T>,
       urlRequest: URLRequest? = nil,
       urlResponse: HTTPURLResponse? = nil,
       data: Data? = nil) {
    self.request = request
    self.result = result
    self.urlRequest = urlRequest
    self.urlResponse = urlResponse
    self.data = data
  }
}

extension APIResponse: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    var string = "\(request)"

    switch result {
    case let .success(value):
      string += " returned \(value.statusCode)"
      let responseString = "\(type(of: value.response))"
      if responseString != "()" {
        string += ": \(responseString)"
      }
    case let .failure(error): string += " failed: \(error)"
    }
    return string
  }

  public var debugDescription: String {
    var string = description
    if let response = try? result.get().response {
      if let debugStringConvertible = response as? CustomDebugStringConvertible {
        string += "\n\(debugStringConvertible.debugDescription)"
      }
    }
    return string
  }
}
