import Foundation

#if canImport(GroupActivities)
  import GroupActivities

  @available(iOS 15, macOS 12, *)
  public struct FloxBxActivity: SharePlayActivity {
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

  @available(iOS 15, macOS 12, *)
  public extension FloxBxActivity {
    init(configuration: GroupActivityConfiguration) {
      self.init(id: configuration.groupActivityID, username: configuration.username)
    }
  }

#endif
