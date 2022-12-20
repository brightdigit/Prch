import Foundation

public struct MissingConfigurationError: Error {
  let key: String
}
