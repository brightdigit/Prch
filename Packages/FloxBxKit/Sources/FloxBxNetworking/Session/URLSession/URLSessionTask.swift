import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSessionTask: SessionTask {}
