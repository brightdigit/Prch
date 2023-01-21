#if os(watchOS) && canImport(SwiftUI)
  import WatchKit
  extension WKInterfaceDevice: Device {}
#endif
