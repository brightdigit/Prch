import Foundation

public enum TodoListDelta: Codable {
  case upsert(UUID, ItemContent)
  case remove([UUID])

  public struct ItemContent: Codable {
    public init(title: String, tags: [String]) {
      self.title = title
      self.tags = tags
    }

    public let title: String
    public let tags: [String]
  }
}
