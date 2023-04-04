import FloxBxAuth
import FloxBxNetworking
import Foundation
import StealthyStash
import FloxBxModeling

#if canImport(Security)

  extension ServiceImpl {
    public convenience init(
      baseURL: URL,
      accessGroup: String,
      serviceName: String,
      headers: [String: String] = ["Content-Type": "application/json; charset=utf-8"],
      coder: JSONCoder = .init(encoder: JSONEncoder(), decoder: JSONDecoder()),
      session: URLSession = .shared
    ) where
      RequestBuilderType == URLRequestBuilder,
      SessionType == URLSession,
      CoderType == JSONCoder,
      AuthorizationContainerType == CredentialsContainer {
      guard let baseURLComponents = URLComponents(
        url: baseURL,
        resolvingAgainstBaseURL: false
      ), let host = baseURL.host ?? baseURLComponents.host else {
        preconditionFailure("Invalid baseURL: \(baseURL)")
      }

      let repository = KeychainRepository(defaultServiceName: serviceName, defaultServerName: host, defaultAccessGroup: accessGroup)
      self.init(
        baseURLComponents: baseURLComponents,
        coder: coder,
        session: session,
        builder: .init(),
        credentialsContainer: CredentialsContainer(repository: repository),
        headers: headers
      )
    }
  }
#endif
