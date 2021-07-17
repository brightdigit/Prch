

public struct CreateTodoRequestContent : Codable {
  public init(title: String) {
    self.title = title
  }
  
  public let title: String
}

