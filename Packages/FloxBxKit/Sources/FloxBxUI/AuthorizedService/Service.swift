import FloxBxAuth
import FloxBxNetworking
import FloxBxRequests

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
  func verifyLogin () async throws -> Bool {
    guard let credentials = try await self.fetchCredentials() else {
      return false
    }
    
    let newToken : String
    do {
      let tokenContainer = try await self.request(SignInRefreshRequest())
      newToken = tokenContainer.token
    } catch {
      newToken = try await self.request(
        SignInCreateRequest(
          body: .DecodableType(
            emailAddress: credentials.username,
            password: credentials.password
          )
        )
      ).token
    }
    
    try self.save(credentials: credentials.withToken(newToken))
    return true
  }
}
