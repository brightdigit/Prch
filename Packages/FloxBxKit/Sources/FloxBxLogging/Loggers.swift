import FelinePine

#if canImport(os)
  import os
#elseif canImport(Logging)
  import Logging
#endif

public struct Loggers: FelinePine.Loggers {
  public typealias LoggerCategory = FloxBxLogging.LoggerCategory

  public static var loggers: [LoggerCategory: Logger] {
    _loggers
  }
}
