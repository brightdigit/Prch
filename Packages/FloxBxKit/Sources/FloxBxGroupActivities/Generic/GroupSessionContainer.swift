import Foundation

#if canImport(GroupActivities)
  import GroupActivities
#endif

internal struct GroupSessionContainer<IDType: Hashable> {
  private let session: Any
  internal let activityID: IDType

  #if canImport(GroupActivities)
    @available(iOS 15, macOS 12, *)
    internal init<ActivityType: SharePlayActivity>(
      groupSession: GroupSession<ActivityType>
    ) where ActivityType.ID == IDType {
      session = groupSession
      activityID = groupSession.activity.id
    }

    @available(iOS 15, macOS 12, *)
    internal func getGroupSession<ActivityType: SharePlayActivity>()
      -> GroupSession<ActivityType> where ActivityType.ID == IDType {
      guard let session = session as? GroupSession<ActivityType> else {
        preconditionFailure()
      }

      return session
    }
  #endif
}
