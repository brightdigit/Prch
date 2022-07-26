//
//  File.swift
//  
//
//  Created by Leo Dion on 4/17/22.
//

import Foundation

public struct GetUserRequest : ClientSuccessRequest {
  public typealias SuccessType = GetUserResponseContent
  
  public static var requiresCredentials: Bool {
    return true
  }
  
  public var path: String {
    return "api/v1/users"
  }
  
  public var parameters: [String : String] {
    [:]
  }
  
  public var method: RequestMethod {
    return .GET
  }
  
  public var headers: [String : String] {
    return [:]
  }
  
  
}
