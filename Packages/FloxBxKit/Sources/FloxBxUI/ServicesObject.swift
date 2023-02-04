import FelinePine
import FloxBxLogging
import Foundation

struct Account {
  let username: String
}

internal class ServicesObject: ObservableObject, LoggerCategorized {
  @Published var account: Account?
  typealias LoggersType = FloxBxLogging.Loggers

  static var loggingCategory: LoggerCategory {
    .reactive
  }

  internal func begin() {}
}
