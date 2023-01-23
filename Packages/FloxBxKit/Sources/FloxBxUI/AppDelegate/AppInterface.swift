import Foundation

public protocol AppInterface {
  static var sharedInterface: AppInterface { get }
  static var currentDevice: Device { get }
  func registerForRemoteNotifications() async
  func unregisterForRemoteNotifications() async
}
