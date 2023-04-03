import StealthyStash

public struct Credentials : StealthyModel {
  public typealias QueryBuilder = CompositeCredentialsQueryBuilder
  
  public let username: String
  public let password: String
  public let token: String?

  public init(username: String, password: String, token: String? = nil) {
    self.username = username
    self.password = password
    self.token = token
  }

  public func withToken(_ token: String) -> Credentials {
    Credentials(username: username, password: password, token: token)
  }

  public func withoutToken() -> Credentials {
    Credentials(username: username, password: password, token: nil)
  }
}


public class CredentialsContainer {
  public init(repository: StealthyRepository, credentials: Credentials? = nil) {
    self.credentials = credentials
    self.repository = repository
  }
  
  var credentials : Credentials?
  let repository : StealthyRepository
  
  public func fetch() async throws -> Credentials? {
    let credentials : Credentials? = try await repository.fetch()
    self.credentials = credentials
    return credentials
  }
  
  public func save(credentials: Credentials) throws {
    if let oldCredentials = self.credentials {
      try self.repository.update(from: oldCredentials, to: credentials)
    } else {
      try self.repository.create(credentials)
    }
  }
  
  public func reset() throws {
    guard let credentials = credentials else {
      return
    }
    
    try self.repository.delete(credentials)
  }
  
  
}
