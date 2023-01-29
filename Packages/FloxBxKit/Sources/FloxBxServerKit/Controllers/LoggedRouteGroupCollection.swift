import FelinePine
import FloxBxLogging
import RouteGroups

@available(*, deprecated, renamed: "RouteGroupCollection")
internal protocol LoggedRouteGroupCollection: RouteGroupCollection, LoggerCategorized
  where LoggersType == FloxBxLogging.Loggers {}

extension LoggedRouteGroupCollection {
  internal static var loggingCategory: LoggerCategory {
    .networking
  }
}

extension RouteGroupCollection where Self: LoggerCategorized {
  internal typealias LoggersType = FloxBxLogging.Loggers
  internal static var loggingCategory: LoggerCategory {
    .ui
  }
}
