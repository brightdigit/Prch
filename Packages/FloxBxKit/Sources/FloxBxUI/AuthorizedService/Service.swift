import FloxBxAuth
import FloxBxNetworking

extension Service
  where AuthorizationContainerType: CredentialsContainer {
  public func save(credentials: Credentials) throws {
    try credentialsContainer.save(credentials: credentials)
  }

  @discardableResult
  public func resetCredentials() throws -> Credentials.ResetResult {
    try credentialsContainer.reset()
  }

  public func fetchCredentials() throws -> Credentials? {
    try credentialsContainer.fetch()
  }
}
