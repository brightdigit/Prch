import Foundation
import FloxBxModeling

public struct UserSubscriptionRequestContent: Codable, ContentEncodable {
  public let tags: [String]
}
