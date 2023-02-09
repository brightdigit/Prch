#if canImport(SwiftUI)
  import FloxBxModels
  import Foundation
  import SwiftUI

  public class AppDelegate: NSObject, ObservableObject {
    @Published public private(set) var mobileDevice: CreateMobileDeviceRequestContent?
    
    public func didRegisterForRemoteNotifications<AppInterfaceType: AppInterface>(
      from _: AppInterfaceType?,
      withDeviceToken deviceToken: Data
    ) {
      guard let topic = Bundle.main.bundleIdentifier else {
        preconditionFailure("There was no `bundleIdentifier`")
      }
      mobileDevice = CreateMobileDeviceRequestContent(
        model: AppInterfaceType.currentDevice.name,
        operatingSystem: AppInterfaceType.currentDevice.systemVersion,
        topic: topic,
        deviceToken: deviceToken
      )
    }
  }
#endif
