#if os(macOS) && canImport(SwiftUI)
  import AppKit
  import SwiftUI

  public typealias ApplicationDelegateAdaptor = NSApplicationDelegateAdaptor
  public typealias AppInterfaceObject = NSApplication

  extension NSApplication: AppInterface {
    public static var sharedInterface: AppInterface {
      NSApplication.shared
    }

    public static var currentDevice: Device {
      ProcessInfo.processInfo
    }
  }
#endif
