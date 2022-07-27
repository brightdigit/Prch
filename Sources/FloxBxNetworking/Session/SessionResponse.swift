public protocol SessionResponse {
  associatedtype DataType
  var statusCode: Int { get }
  var data: DataType? { get }
}
