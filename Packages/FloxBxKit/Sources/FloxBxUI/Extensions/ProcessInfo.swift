import Foundation

extension ProcessInfo: Device {
  public var systemVersion: String {
    operatingSystemVersionString
  }
}
