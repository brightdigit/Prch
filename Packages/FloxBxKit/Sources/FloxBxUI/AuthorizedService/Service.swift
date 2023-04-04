import FloxBxAuth
import FloxBxNetworking

public protocol AuthorizedService : Service {
  func save(credentials: Credentials) throws

  func resetCredentials() throws

  func fetchCredentials() async throws -> Credentials?
}

extension AuthorizedService
  where AuthorizationContainerType: CredentialsContainer {
  public func save(credentials:  FloxBxAuth.Credentials) throws {
    try credentialsContainer.save(credentials: credentials)
  }

  public func resetCredentials() throws {
    try credentialsContainer.reset()
  }

  public func fetchCredentials() async throws ->  FloxBxAuth.Credentials? {
    try await credentialsContainer.fetch()
  }
}

extension ServiceImpl : AuthorizedService where AuthorizationContainerType == CredentialsContainer {

  
  
}

extension AuthorizedService {
  func verifyLogin () async throws {
   // #error("fix re-login")
  }
}
