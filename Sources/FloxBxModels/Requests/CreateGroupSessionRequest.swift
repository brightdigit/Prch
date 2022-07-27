//
//  File.swift
//  
//
//  Created by Leo Dion on 4/14/22.
//

import Foundation
import FloxBxNetworking

public struct CreateGroupSessionResponseContent : Codable {
  public init(id: UUID) {
    self.id = id
  }
  
  public let id : UUID
}

public struct CreateGroupSessionRequest : ClientSuccessRequest {
  public typealias SuccessType = CreateGroupSessionResponseContent
  
  public static var requiresCredentials: Bool {
    return true
  }
  
  public var path: String {
    "api/v1/group-sessions"
  }
  
  public var parameters: [String : String] {
    [:]
  }
  
  public var method: RequestMethod {
    .POST
  }
  
  public var headers: [String : String] {
    [:]
  }
  
  public init () {}
}
