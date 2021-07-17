

public struct CreateTokenRequestContent : Codable {
  public init(emailAddress: String, password: String) {
    self.emailAddress = emailAddress
    self.password = password
  }
  
  public let emailAddress : String
  public let password : String
}
