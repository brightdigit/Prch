import Foundation

#if canImport(GroupActivities)
  import GroupActivities

  @available(iOS 15, macOS 12, *)
  public struct FloxBxActivity: SharePlayActivity {
    public let id: UUID
    public let metadata: GroupActivityMetadata
    public init(id: UUID, username: String) {
      self.id = id
      var metadata = GroupActivityMetadata()
      metadata.title = "\(username) FloxBx"
      metadata.type = .generic
      self.metadata = metadata
    }
  }

  @available(iOS 15, macOS 12, *)
  extension FloxBxActivity {
    public init(configuration: GroupActivityConfiguration) {
      self.init(id: configuration.groupActivityID, username: configuration.username)
    }
  }

#endif
