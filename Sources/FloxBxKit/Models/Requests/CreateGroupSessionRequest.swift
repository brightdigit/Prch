//
//  File.swift
//  
//
//  Created by Leo Dion on 4/14/22.
//

import Foundation

public struct CreateGroupSessionResponseContent : Codable {
  public init(id: UUID) {
    self.id = id
  }
  
  let id : UUID
}

struct CreateGroupSessionRequest : ClientSuccessRequest {
  typealias SuccessType = CreateGroupSessionResponseContent
  
  static var requiresCredentials: Bool {
    return true
  }
  
  var path: String {
    "api/v1/group-sessions"
  }
  
  var parameters: [String : String] {
    [:]
  }
  
  var method: RequestMethod {
    .POST
  }
  
  var headers: [String : String] {
    [:]
  }
  
  
}
