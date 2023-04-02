import FloxBxAuth
import FloxBxNetworking
import StealthyStash

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

extension ServiceImpl : AuthorizedService where AuthorizationContainerType: StealthyRepository {
  
}

extension AuthorizedService {
  func verifyLogin () async throws {
    if let credentials = try await self.fetchCredentials() {
      //#error("fix re-login")
    }
  }
}
