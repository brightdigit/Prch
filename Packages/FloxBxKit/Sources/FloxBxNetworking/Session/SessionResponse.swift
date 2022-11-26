public protocol SessionResponse {
  associatedtype DataType
  // periphery:ignore
  var statusCode: Int { get }
  var data: DataType? { get }
}
