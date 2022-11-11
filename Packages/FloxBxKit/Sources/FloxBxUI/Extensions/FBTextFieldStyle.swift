// swiftlint:disable file_types_order
#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  #if os(watchOS)
    internal typealias FBTextFieldStyle = DefaultTextFieldStyle
  #else
    internal typealias FBTextFieldStyle = RoundedBorderTextFieldStyle
  #endif
#endif
