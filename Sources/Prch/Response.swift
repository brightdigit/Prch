import Foundation

public enum ResponseDecoded<SuccessType, FailureType> {
  case success(SuccessType)
  case failure(Int, FailureType)
}

public protocol DecodedResponse : Response where SuccessType : Decodable, FailureType : Decodable  {
  static var successCode : Int { get }
  init(fromDecoded decoded: ResponseDecodedType)
}

extension DecodedResponse {
  public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
    let decoded : ResponseDecodedType
    switch statusCode {
    case Self.successCode:
      decoded = try .success(decoder.decode(SuccessType.self, from: data))
    default:
      let value = try decoder.decode(FailureType.self, from: data)
      decoded = .failure(statusCode, value)
    }
    self.init(fromDecoded: decoded)
  }
  
  public var statusCode: Int {
    switch self.decoded {
    case .success: return Self.successCode
    case .failure(let statusCode, _): return statusCode
    }
  }
  
  var successful : Bool {
    switch self.decoded {
    case .failure: return false
    case .success: return true
    }
  }
  
  var anyResponse : Any {
    
    switch self.decoded {
    case .failure(_, let value): return value
    case .success(let value): return value
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

@available(*, deprecated, message: "Use DecodedResponse.")
public protocol DeprecatedResponse : Response {
   var success: SuccessType? { get }

   var failure: FailureType? { get }
}

extension DeprecatedResponse {
  public var decoded: ResponseDecoded<SuccessType, FailureType> {
    if let successValue = self.success {
      return .success(successValue)
    } else if let failureValue = self.failure {
      return .failure(self.statusCode, failureValue)
    } else {
      preconditionFailure()
    }
  }
}
public protocol Response: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  associatedtype FailureType
  associatedtype APIType: API
  var statusCode: Int { get }
  var decoded : ResponseDecodedType { get }
  typealias ResponseDecodedType = ResponseDecoded<SuccessType, FailureType>
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
}
