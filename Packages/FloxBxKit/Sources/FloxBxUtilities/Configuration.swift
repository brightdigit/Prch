import Foundation

public enum Configuration {
  #if DEBUG
    public enum Sublimation {
      public static let bucketName = "4WwQUN9AZrppSyLkbzidgo"
      public static let key = "floxbx"
    }
  #endif

  // public static let dsn =
  // "https://d2a8d5241ccf44bba597074b56eb692d@o919385.ingest.sentry.io/5868822"
  public static let accessGroup = "MLT7M394S7.com.brightdigit.FloxBx"
  // public static let appGroup = "group.com.brightdigit.FloxBx"
  public static let serviceName = "floxbx.work"

  public static let productionBaseURL: URL = {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = Self.serviceName
    return URL(components: urlComponents)
  }()
}
