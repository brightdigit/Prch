//
//  File.swift
//  
//
//  Created by Leo Dion on 2/3/23.
//

import Foundation
import Combine
import FloxBxNetworking
import FloxBxModels

class TodoListObject : ObservableObject {
  internal init(groupActivityID: UUID?, service: any Service, items: [TodoContentItem] = [], isLoaded: Bool = false, lastErrror: Error? = nil) {
    self.groupActivityID = groupActivityID
    self.service = service
    self.items = items
    self.isLoaded = isLoaded
    self.lastErrror = lastErrror
  }
  
  let groupActivityID : UUID?
  let service: any Service
  @Published var items : [TodoContentItem]
  @Published var isLoaded : Bool
  @Published var lastErrror : Error?
  
  
  
  func saveItem(_ item: TodoContentItem, onlyNew: Bool = false) {
    
  }
  
  func deleteItems(
    atIndexSet indexSet: IndexSet
  ) {
    
  }
  
  func logout () {
    
  }
  
  func addItem(_ item: TodoContentItem) {
    
  }
  
  func requestSharing() {
    
  }
}
