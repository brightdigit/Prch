import Foundation

public struct GroupActivityConfiguration {
  public init(groupActivityID: UUID, username: String) {
    self.groupActivityID = groupActivityID
    self.username = username
  }

  let groupActivityID: UUID
  let username: String
}
