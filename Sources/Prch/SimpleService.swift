import Foundation
import PrchModel

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@available(*, deprecated)
struct SimpleCreds {
  let userName: String
  let password: String
  let token: String?

  var httpHeaders: [String: String] {
    fatalError()
  }
}

@available(*, deprecated)
public class SimpleCredContainer {
  public init() {}
  func fetch() async throws -> SimpleCreds? {
    fatalError()
  }
}
