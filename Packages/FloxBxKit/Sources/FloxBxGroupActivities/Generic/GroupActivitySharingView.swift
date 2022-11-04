#if canImport(SwiftUI) && canImport(UIKit) && canImport(GroupActivities)
  import GroupActivities
  import SwiftUI
  import UIKit

  @available(iOS 15.4, *)
  /// SwiftUI View for `GroupActivitySharingController`
  public struct GroupActivitySharingView<ActivityType: GroupActivity>: UIViewControllerRepresentable {
    public init(activity: ActivityType) {
      controller = try! GroupActivitySharingController(activity)
    }

    private let controller: GroupActivitySharingController

    public func makeUIViewController(context _: Context) -> GroupActivitySharingController {
      controller
    }

    public func updateUIViewController(_: GroupActivitySharingController, context _: Context) {}

    public typealias UIViewControllerType = GroupActivitySharingController
  }
#endif
