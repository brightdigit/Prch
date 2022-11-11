#if canImport(AppKit)
  import AppKit
  extension NSTextContentType {
    internal static let emailAddress: NSTextContentType = .username
  }
#endif
