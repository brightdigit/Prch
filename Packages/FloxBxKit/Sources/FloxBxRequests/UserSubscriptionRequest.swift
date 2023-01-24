//
import FloxBxModels
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

public struct UserSubscriptionRequest: ClientBodyRequest {
  public typealias BodyType = UserSubscriptionRequestContent
  public static var requiresCredentials: Bool {
    true
  }

  public let body: UserSubscriptionRequestContent

  public var path: String

  public var parameters: [String: String]

  public var method: FloxBxNetworking.RequestMethod

  public var headers: [String: String]
}
