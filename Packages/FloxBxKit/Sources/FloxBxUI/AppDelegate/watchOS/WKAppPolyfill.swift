// swiftlint:disable file_types_order
#if os(watchOS) && canImport(SwiftUI)
  import SwiftUI
  import WatchKit

  public typealias ApplicationDelegateAdaptor = WKDelegateAdaptor
  public typealias AppInterfaceObject = WKAppPolyfill

  extension WKAppPolyfill: AppInterface {
    public static var currentDevice: Device {
      WKInterfaceDevice.current()
    }

    public static var sharedInterface: AppInterface {
      WKAppPolyfill.shared()
    }
  }

  #if swift(>=5.7)
    public typealias WKAppPolyfill = WKApplication
  #else
    public typealias WKAppPolyfill = WKExtension
  #endif

#endif
