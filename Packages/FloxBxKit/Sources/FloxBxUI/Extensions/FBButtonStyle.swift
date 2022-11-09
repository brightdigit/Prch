// swiftlint:disable file_types_order
#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  #if os(watchOS)
    internal typealias FBButtonStyle = DefaultButtonStyle
  #else
    internal typealias FBButtonStyle = BorderlessButtonStyle
  #endif

#endif
