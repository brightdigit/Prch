import Foundation
public protocol SessionResponse<DataType> {
  associatedtype DataType
  // periphery:ignore
  var statusCode: Int { get }
  var data: DataType? { get }
}


public protocol GenericSessionResponse<DataType> {
  associatedtype DataType
  var statusCode : Int { get }
  var data : DataType { get }
}
