import Foundation

public struct GroupActivityConfiguration {
  public let groupActivityID: UUID
  public let username: String
  public init(groupActivityID: UUID, username: String) {
    self.groupActivityID = groupActivityID
    self.username = username
  }
}
