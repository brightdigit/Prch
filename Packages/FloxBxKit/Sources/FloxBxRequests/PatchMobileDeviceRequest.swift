import FloxBxModels
import FloxBxNetworking
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct PatchMobileDeviceRequest: ClientBodyRequest {
  public typealias BodyType = PatchMobileDeviceRequestContent

  public static var requiresCredentials: Bool {
    true
  }

  public let id: UUID
  public let body: PatchMobileDeviceRequestContent

  public var path: String {
    "api/v1/device/mobile/\(id)"
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: FloxBxNetworking.RequestMethod {
    .PATCH
  }

  public var headers: [String: String] {
    [:]
  }

  public init(id: UUID, body: PatchMobileDeviceRequestContent) {
    self.id = id
    self.body = body
  }
}
