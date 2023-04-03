import FloxBxAuth
import FloxBxNetworking
import StealthyStash

public protocol CredentialsContainer {
  var credentials : Credentials? { set get }
}

public protocol AuthorizedService : Service {
  
  func upsert(credentials newCredentials: Credentials, from oldCredentials: Credentials?) throws

  func delete(credentials: Credentials) throws
//  @discardableResult
//  func resetCredentials() throws -> Credentials.ResetResult

  func fetchCredentials() async throws -> Credentials?
}

extension AuthorizedService
  where AuthorizationContainerType: StealthyRepository {
  public func upsert(credentials newCredentials: Credentials, from oldCredentials: Credentials?) throws {
    if let oldCredentials {
      try self.credentialsContainer.update(from: oldCredentials, to: newCredentials)
    } else {
      try self.credentialsContainer.create(newCredentials)
    }
  }

  public func delete(credentials: Credentials) throws {
    try self.credentialsContainer.delete(credentials)
  }

  public func fetchCredentials() async throws ->  FloxBxAuth.Credentials? {
    try await credentialsContainer.fetch()
  }
}

extension AuthorizedService where Self : CredentialsContainer, Self.AuthorizationContainerType.AuthorizationType == Credentials {
  public func upsert(credentials newCredentials: Credentials) throws {
    try self.upsert(credentials: newCredentials, from: self.credentials)
  }
  
  public func clearCredentials () throws {
    guard let credentials = self.credentials else {
      return
    }
    try self.delete(credentials: credentials)
  }
  
  public mutating func refreshCredentials() async throws ->  FloxBxAuth.Credentials? {
    let credentials = try await credentialsContainer.fetch()
    self.credentials = credentials
    return credentials
  }
}

extension ServiceImpl : AuthorizedService, CredentialsContainer where AuthorizationContainerType: StealthyRepository {
  
  
}
//
//extension AuthorizedService {
//  func verifyLogin () async throws {
//    if let credentials = try await self.fetchCredentials() {
//      //#error("fix re-login")
//    }
//  }
//}
