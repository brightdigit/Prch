import FloxBxAuth
import FloxBxNetworking

public protocol AuthorizedService : Service {
  func save(credentials: Credentials) throws

  @discardableResult
  func resetCredentials() throws -> Credentials.ResetResult

  func fetchCredentials() throws -> Credentials?
}

extension AuthorizedService
  where AuthorizationContainerType: CredentialsContainer {
  public func save(credentials:  FloxBxAuth.Credentials) throws {
    try credentialsContainer.save(credentials: credentials)
  }

  @discardableResult
  public func resetCredentials() throws ->  FloxBxAuth.Credentials.ResetResult {
    try credentialsContainer.reset()
  }

  public func fetchCredentials() throws ->  FloxBxAuth.Credentials? {
    try credentialsContainer.fetch()
  }
}

extension ServiceImpl : AuthorizedService where AuthorizationContainerType: CredentialsContainer {
  
}

extension AuthorizedService {
  func verifyLogin () async throws {
    if let credentials = try self.fetchCredentials() {
      #error("fix re-login")
    }
  }
}
