import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

protocol GenericService {
  func request<RequestType: GenericRequest>(
    _ request: RequestType
  ) async throws -> RequestType.SuccessType
}
