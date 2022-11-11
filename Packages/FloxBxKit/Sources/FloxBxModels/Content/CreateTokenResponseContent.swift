public struct CreateTokenResponseContent: Codable {
  public let token: String

  public init(token: String) {
    self.token = token
  }
}
