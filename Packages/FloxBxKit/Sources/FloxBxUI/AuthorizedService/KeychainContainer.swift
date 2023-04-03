import FloxBxAuth
import FloxBxNetworking

#if canImport(Security)

  extension KeychainContainer: AuthorizationContainer {
    public typealias AuthorizationType = Credentials
  }
#endif
