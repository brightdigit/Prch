import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@available(*, deprecated)
extension URLSessionTask: SessionTask {}
