import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

enum RequestError: Error {
  case missingData
  case invalidResponse(URLResponse?)
}
