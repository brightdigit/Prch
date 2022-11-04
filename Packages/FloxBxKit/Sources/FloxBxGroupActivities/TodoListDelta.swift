import Foundation

public enum TodoListDelta: Codable {
  case upsert(UUID, ItemContent)
  case remove([UUID])

  public struct ItemContent: Codable {
    public init(title: String) {
      self.title = title
    }

    public let title: String
  }
}
