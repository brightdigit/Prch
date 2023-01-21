// swiftlint:disable file_types_order
#if canImport(WatchKit) && canImport(SwiftUI)
  import SwiftUI
  import WatchKit

  #if swift(>=5.7)
    public typealias WKDelegateAdaptor = WKApplicationDelegateAdaptor
  #else
    public typealias WKDelegateAdaptor = WKExtensionDelegateAdaptor
  #endif

  #if swift(>=5.7)
    public typealias WKDelegate = WKApplicationDelegate
  #else
    public typealias WKDelegate = WKExtensionDelegate
  #endif

  extension AppDelegate: WKDelegate {
    public func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
      didRegisterForRemoteNotifications(
        from: WKAppPolyfill.shared(),
        withDeviceToken: deviceToken
      )
    }

    public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
      debugPrint("Unable to register logging: \(error.localizedDescription)")
    }
  }
#endif
