// swiftlint:disable:this file_name
#if os(macOS) && canImport(AppKit)
  import AppKit
  extension AppDelegate: NSApplicationDelegate {
    public func application(
      _: NSApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      didRegisterForRemoteNotifications(
        from: NSApplication.shared,
        withDeviceToken: deviceToken
      )
    }

    public func application(
      _: NSApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      debugPrint("Unable to register logging: \(error.localizedDescription)")
    }
  }
#endif
