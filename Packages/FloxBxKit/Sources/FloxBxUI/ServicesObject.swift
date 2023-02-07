import FelinePine
import FloxBxNetworking
import FloxBxLogging
import Foundation

struct Account {
  let username: String
}

internal class ServicesObject: ObservableObject, LoggerCategorized {
  internal init(account: Account? = nil, service: any Service) {
    self.account = account
    self.service = service
  }
  
  @Published var account: Account?
  let service: any Service
  
  typealias LoggersType = FloxBxLogging.Loggers

  static var loggingCategory: LoggerCategory {
    .reactive
  }

  internal func begin() {}
}
