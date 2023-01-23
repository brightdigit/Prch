//
//  File.swift
//
//
//  Created by Leo Dion on 12/2/22.
//
import FloxBxNetworking
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct DeleteMobileDeviceRequest: ClientVoidRequest {
  public static var requiresCredentials: Bool {
    true
  }

  public var path: String {
    "api/v1/device/mobile/\(id)"
  }

  public var parameters: [String: String] {
    [:]
  }

  public var method: FloxBxNetworking.RequestMethod {
    .DELETE
  }

  public var headers: [String: String] {
    [:]
  }

  public let id: UUID

  public init(id: UUID) {
    self.id = id
  }
}
