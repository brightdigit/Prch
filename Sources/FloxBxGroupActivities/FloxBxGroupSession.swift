#if canImport(GroupActivities)
  import GroupActivities
#endif

public protocol ActivityGroupSessionContainer {
  #if canImport(GroupActivities)

    @available(iOS 15, macOS 12, *)
    func getValue<ActivityType: GroupActivity>() -> GroupSession<ActivityType>?
  #endif
}
