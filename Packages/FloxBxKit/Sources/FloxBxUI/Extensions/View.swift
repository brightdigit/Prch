#if canImport(SwiftUI)
  import FelinePine
  import FloxBxLogging
  import SwiftUI

  extension View where Self: LoggerCategorized {
    internal typealias LoggersType = FloxBxLogging.Loggers

    internal static var loggingCategory: LoggerCategory {
      .ui
    }
  }

#endif
