#if os(watchOS) && canImport(SwiftUI)
  import SwiftUI
  import WatchKit

  #if swift(>=5.7)
    public typealias WKAppPolyfill = WKApplication
    public typealias WKDelegateAdaptor = WKApplicationDelegateAdaptor
    public typealias WKDelegate = WKApplicationDelegate
  #else
    public typealias WKAppPolyfill = WKExtension
    public typealias WKDelegateAdaptor = WKExtensionDelegateAdaptor
    public typealias WKDelegate = WKExtensionDelegate
  #endif

  extension WKInterfaceDevice: Device {}
  extension WKAppPolyfill: AppInterface {
    public static var currentDevice: Device {
      WKInterfaceDevice.current()
    }

    public static var sharedInterface: AppInterface {
      WKAppPolyfill.shared()
    }
  }

  public typealias ApplicationDelegateAdaptor = WKDelegateAdaptor
  public typealias AppInterfaceObject = WKAppPolyfill
#endif
