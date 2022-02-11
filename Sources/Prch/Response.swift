import Foundation

public protocol Response: CustomDebugStringConvertible, CustomStringConvertible {
  associatedtype SuccessType
  associatedtype FailureType
  associatedtype APIType: API
  var statusCode: Int { get }
  var response: ClientResult<SuccessType, FailureType> { get }
  typealias ResponseDecodedType = ResponseResult<SuccessType, FailureType>
  init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws
}
