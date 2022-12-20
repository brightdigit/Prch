import FloxBxModels
import Foundation

extension TodoContentItem {
  public var text: String {
    .init(([title] + tags).joined(separator: " #"))
  }
}
