import FloxBxModeling
public struct CreateUserResponseContent: Codable, Content {
  public let token: String
  public init(token: String) {
    self.token = token
  }
}
