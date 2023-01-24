internal protocol HeaderProvider {
  associatedtype AuthorizationType: AuthorizationContainer
  associatedtype RequestBuilderType: RequestBuilder
  var credentialsContainer: AuthorizationType { get }
  var builder: RequestBuilderType { get }
  var headers: [String: String] { get }
}

extension HeaderProvider {
  public static func headers(
    withCredentials credentialsContainer: AuthorizationType?,
    from builder: RequestBuilderType,
    mergedWith headers: [String: String]
  ) throws -> [String: String] {
    let creds = try credentialsContainer?.fetch()

    let authorizationHeaders: [String: String]
    if let creds = creds {
      authorizationHeaders = builder.headers(basedOnCredentials: creds)
    } else {
      authorizationHeaders = [:]
    }

    return headers.merging(authorizationHeaders) { _, rhs in
      rhs
    }
  }

  public func headers(
    withCredentials requiresCredentials: Bool
  ) throws -> [String: String] {
    try Self.headers(
      withCredentials: requiresCredentials ? credentialsContainer : nil,
      from: builder,
      mergedWith: headers
    )
  }
}
