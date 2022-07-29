import Foundation

#if canImport(GroupActivities)
  import GroupActivities

  @available(iOS 15, macOS 12, *)
  public struct FloxBxActivity: GroupActivity {
    public let id: UUID
    public init(id: UUID, username: String) {
      self.id = id
      var metadata = GroupActivityMetadata()
      metadata.title = "\(username) FloxBx"
      metadata.type = .generic
      self.metadata = metadata
    }

    public let metadata: GroupActivityMetadata
  }

#endif
