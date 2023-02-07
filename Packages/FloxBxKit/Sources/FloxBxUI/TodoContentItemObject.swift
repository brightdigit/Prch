//
//  File.swift
//  
//
//  Created by Leo Dion on 2/3/23.
//

import Foundation
import FloxBxModels
import Combine
import FloxBxRequests
import FloxBxNetworking

#warning("change this name")
class TodoContentItemObject : ObservableObject {
  let saveTrigger = PassthroughSubject<Void, Never>()
  let groupActivityID : UUID?
  let service: any Service
  @Published var text : String
  @Published var item : TodoContentItem
  
  var isSaved : Bool {
    return false
  }
  
  init(item : TodoContentItem, service: any Service, groupActivityID: UUID?) {
    self.text = item.text
    self.item = item
    self.groupActivityID = groupActivityID
    self.service = service
    
    saveTrigger.compactMap{ _ -> UpsertTodoRequest? in
      if item.isSaved {
        return nil
      }
      let content = CreateTodoRequestContent(text: self.text)
      return UpsertTodoRequest(
        groupActivityID: groupActivityID,
        itemID: self.item.serverID,
        body: content
      )
    }.map { request -> Future<CreateTodoResponseContent,Error> in
      Future<CreateTodoResponseContent, Error> {
        try await self.service.request(request)
      }
    }.switchToLatest()
  }
  
  func beginSave () {
    
  }
  
  
}
