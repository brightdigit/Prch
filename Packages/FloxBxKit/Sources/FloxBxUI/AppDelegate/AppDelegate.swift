#if canImport(SwiftUI)
  import FloxBxModels
  import Foundation
  import SwiftUI

  public class AppDelegate: NSObject, ObservableObject {
    @Published var mobileDevice: CreateMobileDeviceRequestContent?
    public func didRegisterForRemoteNotifications<AppInterfaceType: AppInterface>(from _: AppInterfaceType?, withDeviceToken deviceToken: Data) {
      mobileDevice = CreateMobileDeviceRequestContent(
        model: AppInterfaceType.currentDevice.name,
        operatingSystem: AppInterfaceType.currentDevice.systemVersion,
        topic: Bundle.main.bundleIdentifier!,
        deviceToken: deviceToken
      )
    }
  }
#endif
