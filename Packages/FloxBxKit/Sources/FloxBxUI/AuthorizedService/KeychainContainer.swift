import FloxBxAuth
import FloxBxNetworking

//#if canImport(Security)
//
//  extension LegacyKeychainContainer: AuthorizationContainer {
//    public typealias AuthorizationType = Credentials
//  }
//#endif

extension CredentialsContainer : AuthorizationContainer {


  
  public typealias AuthorizationType = Credentials
  
  
}
