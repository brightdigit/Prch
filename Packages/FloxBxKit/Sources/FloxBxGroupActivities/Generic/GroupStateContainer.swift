import Foundation

#if canImport(GroupActivities)
  import GroupActivities
#endif

/// Contains the state of whether a GroupActivity can be started.
class GroupStateContainer {
  let _observer: Any?
  @Published private(set) var isEligible = false

  init() {
    #if canImport(GroupActivities)
      if #available(iOS 15, *) {
        let observer = GroupStateObserver()
        self._observer = observer
        observer.$isEligibleForGroupSession.assign(to: &self.$isEligible)
        self.isEligible = observer.isEligibleForGroupSession
      } else {
        _observer = nil
      }
    #else
      _observer = nil
    #endif
  }
}
