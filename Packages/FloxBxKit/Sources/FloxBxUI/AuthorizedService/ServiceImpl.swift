import FloxBxAuth
import FloxBxNetworking
import Foundation

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
      AuthorizationContainerType == KeychainContainer {
      guard let baseURLComponents = URLComponents(
        url: baseURL,
        resolvingAgainstBaseURL: false
      ) else {
        preconditionFailure("Invalid baseURL: \(baseURL)")
      }

      self.init(
        baseURLComponents: baseURLComponents,
        coder: coder,
        session: session,
        builder: .init(),
        credentialsContainer:
        KeychainContainer(
          accessGroup: accessGroup,
          serviceName: serviceName
        ),
        headers: headers
      )
    }
  }
#endif
