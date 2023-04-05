//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 2/3/23.
//

import Combine
import FloxBxAuth
import FloxBxNetworking
import FloxBxRequests

class AuthorizationObject: ObservableObject {
  internal init(service: any AuthorizedService, account: Account? = nil) {
    self.service = service
    self.account = account
  }
  
  
  let service : any AuthorizedService
  @Published var account: Account?
  let compeletedSubject = PassthroughSubject<Void, Never>()
  internal func beginSignup(withCredentials credentials: Credentials) {
    Task{
      let tokenContainer = try await self.service.request(SignUpRequest(body: .init(emailAddress: credentials.username, password: credentials.password)))
      let newCreds = credentials.withToken(tokenContainer.token)
      try self.service.save(credentials: newCreds)
      compeletedSubject.send()
    }
  }
  
  func beginSignIn(withCredentials credentials: Credentials) {
    Task{
      let tokenContainer = try await self.service.request(SignInCreateRequest(body: .init(emailAddress: credentials.username, password: credentials.password)))
      let newCreds = credentials.withToken(tokenContainer.token)
      try self.service.save(credentials: newCreds)
      compeletedSubject.send()
    }
  }
}
