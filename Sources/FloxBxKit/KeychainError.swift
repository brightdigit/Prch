import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

enum KeychainError: Error {
  case unexpectedPasswordData
  case noPassword
  case unhandledError(status: OSStatus)
}
