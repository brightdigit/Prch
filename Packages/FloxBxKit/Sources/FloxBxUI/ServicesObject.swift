import FelinePine
import FloxBxAuth
import Sublimation
import FloxBxUtilities
import FloxBxNetworking
import FloxBxLogging
import Foundation

struct Account {
  let username: String
}

internal class ServicesObject: ObservableObject, LoggerCategorized {
  internal init() {
    //self.account = account
    self.service = service
    
    self.$service.compactMap{$0}.map { service in
      service
    }
  }
  
  //@Published var account: Account?
  @Published var service: (any AuthorizedService)?
  @Published var error : Error?
  
  typealias LoggersType = FloxBxLogging.Loggers

  static var loggingCategory: LoggerCategory {
    .reactive
  }

  internal func begin() {
#if DEBUG
    Task {
      let service = await self.developerService(fallbackURL: Configuration.productionBaseURL)
      await MainActor.run {
        self.service = service
        
      }
    }
#else
    self.service = ServiceImpl(
      baseURL: Configuration.productionBaseURL,
      accessGroup: Configuration.accessGroup,
      serviceName: Configuration.serviceName
    )
#endif
  }
  
//  func logout () {
//    guard let service = self.service else {
//      assertionFailure("Service is not available.")
//      return
//    }
//    
//    do {
//      try service.resetCredentials()
//    } catch {
//      self.error = error
//    }
//  }
  
#if DEBUG
  private static func fetchBaseURL() async throws -> URL {
    do {
      guard let url = try await KVdb.url(
        withKey: Configuration.Sublimation.key,
        atBucket: Configuration.Sublimation.bucketName
      ) else {
        throw DeveloperServerError.noServer
      }
      return url
    } catch {
      throw DeveloperServerError.sublimationError(error)
    }
  }

  internal func developerService(fallbackURL: URL) async -> any AuthorizedService {
    let baseURL: URL
    do {
      baseURL = try await Self.fetchBaseURL()
      Self.logger.debug("Found service url: \(baseURL)")
    } catch {
      Task { @MainActor in
        self.error = error
      }
      baseURL = fallbackURL
    }
    return ServiceImpl<JSONCoder, URLSession, URLRequestBuilder, KeychainContainer>(
      baseURL: baseURL,
      accessGroup: Configuration.accessGroup,
      serviceName: Configuration.serviceName
    )
  }
#endif
}
