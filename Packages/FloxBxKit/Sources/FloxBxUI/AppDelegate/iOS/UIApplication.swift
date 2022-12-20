#if os(iOS) && canImport(SwiftUI)
  import SwiftUI
  import UIKit
  extension UIDevice: Device {}
  extension UIApplication: AppInterface {
    public static var sharedInterface: AppInterface {
      UIApplication.shared
    }

    public static var currentDevice: Device {
      UIDevice.current
    }
  }

  public typealias AppInterfaceObject = UIApplication

  public typealias ApplicationDelegateAdaptor = UIApplicationDelegateAdaptor

#endif
