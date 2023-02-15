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

class TodoObject : ObservableObject {
  let saveTrigger = PassthroughSubject<Void, Never>()
  let groupActivityID : UUID?
  let service: any Service
  @Published var text : String
  @Published var item : TodoContentItem
  @Published var lastError : Error?
  
  var isSaved : Bool {
    return false
  }
  
  init(item : TodoContentItem, service: any Service, groupActivityID: UUID?) {
    self.text = item.text
    self.item = item
    self.groupActivityID = groupActivityID
    self.service = service
    
    let savedItemPublisher = saveTrigger
    .compactMap{ _ -> UpsertTodoRequest? in
      if item.isSaved {
        return nil
      }
      let content = CreateTodoRequestContent(text: self.text)
      return UpsertTodoRequest(
        groupActivityID: groupActivityID,
        itemID: self.item.serverID,
        body: content
      )
    }
    .map { request -> Future<CreateTodoResponseContent,Error> in
      Future<CreateTodoResponseContent, Error> {
        try await self.service.request(request)
      }
    }
    .switchToLatest()
    .map(TodoContentItem.init(content:))
    .map(Result.success)
    .catch{ error in
      Just(.failure(error))
    }.share()
    
    savedItemPublisher.compactMap{ try? $0.get() }.receive(on: DispatchQueue.main).assign(to: &self.$item)
    
    savedItemPublisher.map { result in
      guard case let .failure(error) = result else {
        return nil
      }
      
      return error
    }.receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
  }
  
  func beginSave () {
    
  }
  
  
}
