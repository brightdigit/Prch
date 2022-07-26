//
//  File.swift
//  
//
//  Created by Leo Dion on 4/17/22.
//

import Foundation

public struct GetUserResponseContent : Codable {
  public init(id: UUID, username: String) {
    self.id = id
    self.username = username
  }
  
  let id : UUID
  let username : String
}
