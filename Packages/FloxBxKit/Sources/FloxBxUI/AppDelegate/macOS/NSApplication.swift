#if os(macOS) && canImport(SwiftUI)
  import AppKit
  import SwiftUI
  extension ProcessInfo: Device {
    public var systemVersion: String {
      operatingSystemVersionString
    }
  }

  extension NSApplication: AppInterface {
    public static var sharedInterface: AppInterface {
      NSApplication.shared
    }

    public static var currentDevice: Device {
      ProcessInfo.processInfo
    }
  }

  public typealias ApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
  public typealias AppInterfaceObject = NSApplication
#endif
