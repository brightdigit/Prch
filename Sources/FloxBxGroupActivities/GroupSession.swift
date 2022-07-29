import Foundation

#if canImport(GroupActivities)

  import GroupActivities

  @available(iOS 15, macOS 12, *)
  extension GroupSession<FloxBxActivity>: ActivityGroupSessionContainer {
    public func getValue<ActivityType>() -> GroupSession<ActivityType>? where ActivityType: GroupActivity {
      self as? GroupSession<ActivityType>
    }
  }
#endif
