//
//  SwiftUIView.swift
//  
//
//  Created by Leo Dion on 2/3/23.
//

import Combine
import FloxBxAuth
import FloxBxNetworking

class AuthorizationObject: ObservableObject {
  internal init(service: any Service, account: Account? = nil) {
    self.service = service
    self.account = account
  }
  
  
  let service : any Service
  @Published var account: Account?
  internal func beginSignup(withCredentials credentials: Credentials) {
  }
  
  func beginSignIn(withCredentials credentials: Credentials) {
  }
}
