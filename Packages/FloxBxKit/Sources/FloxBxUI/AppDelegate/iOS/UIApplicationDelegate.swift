#if os(iOS)
  import Foundation
  import UIKit

  extension AppDelegate: UIApplicationDelegate {
    public func application(_ app: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      didRegisterForRemoteNotifications(from: app, withDeviceToken: deviceToken)
    }

    public func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      debugPrint("Unable to register logging: \(error.localizedDescription)")
    }
  }
#endif
