#if canImport(WatchKit) && canImport(SwiftUI)
  import SwiftUI
  import WatchKit
  extension AppDelegate: WKDelegate {
    public func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
      didRegisterForRemoteNotifications(from: WKAppPolyfill.shared(), withDeviceToken: deviceToken)
    }

    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
      debugPrint("Unable to register logging: \(error.localizedDescription)")
    }
  }
#endif
