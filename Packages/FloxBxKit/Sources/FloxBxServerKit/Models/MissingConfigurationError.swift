import Foundation

public struct MissingConfigurationError: Error {
  public let key: String
}
