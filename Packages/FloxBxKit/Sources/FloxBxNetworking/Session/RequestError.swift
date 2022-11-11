import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

internal enum RequestError: Error {
  case missingData
  case invalidResponse(URLResponse?)
}
