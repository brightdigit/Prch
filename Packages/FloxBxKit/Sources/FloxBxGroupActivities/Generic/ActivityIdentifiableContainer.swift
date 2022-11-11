import Foundation

#if canImport(GroupActivities)
  import GroupActivities
#endif

/// iOS 14 friendly abstraction for GroupActivities Activity
public struct ActivityIdentifiableContainer<IDType: Hashable>: Identifiable {
  /// Activity ID
  public let id: IDType
  private let activity: Any

  #if canImport(GroupActivities)
    @available(iOS 15, macOS 12, *)
    internal init<GroupActivityType: Identifiable & GroupActivity>(
      activity: GroupActivityType
    ) where GroupActivityType: GroupActivity, GroupActivityType.ID == IDType {
      self.activity = activity
      id = activity.id
    }
  #endif

  /// Gets the GroupActivity inside the container
  /// - Returns: The GroupAcitivty
  @available(iOS 15, *)
  public func getGroupActivity<GroupActivityType>() -> GroupActivityType {
    guard let actvitiy = activity as? GroupActivityType else {
      preconditionFailure()
    }
    return actvitiy
  }
}
