#if canImport(Combine)
  import Foundation

  #if canImport(GroupActivities)
    import GroupActivities
  #endif

  /// Contains the state of whether a GroupActivity can be started.
  internal class GroupStateContainer {
    private let anyObserver: Any?
    @Published internal private(set) var isEligible = false

    internal init() {
      #if canImport(GroupActivities)
        if #available(macOS 12, iOS 15, *) {
          let observer = GroupStateObserver()
          self.anyObserver = observer
          observer.$isEligibleForGroupSession.assign(to: &self.$isEligible)
          self.isEligible = observer.isEligibleForGroupSession
        } else {
          anyObserver = nil
        }
      #else
        anyObserver = nil
      #endif
    }
  }
#endif
