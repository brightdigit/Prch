import Foundation

public enum Configuration {
  public static let dsn =
    "https://d2a8d5241ccf44bba597074b56eb692d@o919385.ingest.sentry.io/5868822"
  public static let accessGroup = "MLT7M394S7.com.brightdigit.FloxBx"
  public static let appGroup = "group.com.brightdigit.FloxBx"
  public static let serviceName = "floxbx.work"
  public static let productionBaseURL: URL = {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = Self.serviceName
    return urlComponents.url!
  }()

  public enum Sublimation {
    public static let bucketName = "4WwQUN9AZrppSyLkbzidgo"
    public static let key = "floxbx"
  }
}

public protocol Notifiable: Codable {
  associatedtype PayloadType: Codable
  var title: String { get }
  var deviceToken: Data { get }
  var topic: String { get }
  var payload: PayloadType { get }
}

public struct PayloadNotification<Payload: Codable>: Codable {
  public init(topic: String, deviceToken: Data, payload: Payload) {
    self.topic = topic
    self.deviceToken = deviceToken
    self.payload = payload
  }

  public let topic: String
  public let deviceToken: Data
  public let payload: Payload
}

public protocol NotificationContent {
  var title: String { get }
}

extension PayloadNotification: Notifiable where Payload: NotificationContent {
  public var title: String {
    payload.title
  }
}

public struct TagPayload: Codable, NotificationContent {
  public init(action: TagPayload.Action, name: String) {
    self.name = name
    self.action = action
  }

  public let name: String
  public let action: Action

  public enum Action: String, Codable {
    case added
    case removed
  }

  public var title: String {
    switch action {
    case .added:
      return "New Todo Item tagged #\(name)"
    case .removed:

      return "Todo Item tagged #\(name) Removed"
    }
  }
}
