import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public enum RequestError: Error {
  case missingData
  case statusCode(Int)
  case invalidResponse(URLResponse?)
}
