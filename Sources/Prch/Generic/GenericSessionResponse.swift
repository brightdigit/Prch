import Foundation

protocol GenericSessionResponse {
  var statusCode: Int { get }
  var data: Data { get }
}
