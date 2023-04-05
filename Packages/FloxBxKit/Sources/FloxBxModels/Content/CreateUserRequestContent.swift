import FloxBxModeling
public struct CreateUserRequestContent: Codable, Content {
  public let emailAddress: String
  public let password: String
  public init(emailAddress: String, password: String) {
    self.emailAddress = emailAddress
    self.password = password
  }
}
