public struct CreateUserResponseContent: Codable {
  public init(token: String) {
    self.token = token
  }

  public let token: String
}
