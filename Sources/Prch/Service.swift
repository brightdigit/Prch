import Foundation
import PrchModel

public protocol GenericService {
  func request<RequestType: GenericRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType.DecodableType
}
