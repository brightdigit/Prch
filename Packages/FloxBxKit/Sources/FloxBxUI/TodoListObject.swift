//
//  File.swift
//  
//
//  Created by Leo Dion on 2/3/23.
//

import Foundation
import Combine
import FloxBxNetworking

class TodoListObject : ObservableObject {
  let groupActivityID : UUID?
  let service: any Service
  
  init() {
    fatalError()
  }
}
