#if canImport(SwiftUI) && canImport(UIKit) && canImport(GroupActivities)
  import GroupActivities
  import SwiftUI
  import UIKit

  /// SwiftUI View for `GroupActivitySharingController`
  @available(iOS 15.4, *)
  public struct GroupActivitySharingView<
    ActivityType: GroupActivity
  >: UIViewControllerRepresentable {
    public typealias UIViewControllerType = GroupActivitySharingController

    private let controller: GroupActivitySharingController

    public init(activity: ActivityType) {
      do {
        controller = try GroupActivitySharingController(activity)
      } catch {
        preconditionFailure(error.localizedDescription)
      }
    }

    public func makeUIViewController(
      context _: Context
    ) -> GroupActivitySharingController {
      controller
    }

    public func updateUIViewController(
      _: GroupActivitySharingController,
      context _: Context
    ) {}
  }
#endif
