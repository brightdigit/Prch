import FloxBxAuth
import FloxBxRequests
import Foundation

extension ApplicationObject {
  internal func setupCredentials() {
    Task {
      let credentials: Credentials?
      let error: Error?
      do {
        credentials = try await service.fetchCredentials()
        error = nil
      } catch let caughtError {
        error = caughtError
        credentials = nil
      }
      
      if let error = error {
        onError(error)
      }
      
      if let credentials = credentials {
        beginSignIn(withCredentials: credentials)
      } else {
        Task{ @MainActor in
          self.requiresAuthentication = true
        }
      }
    }
  }

  internal func beginSignup(withCredentials credentials: Credentials) {
    service.beginRequest(
      SignUpRequest(
        body: .init(
          emailAddress: credentials.username,
          password: credentials.password
        )
      )
    ) { result in
      let newCredentialsResult = result.map { content in
        credentials.withToken(content.token)
      }
      .tryMap { creds -> Credentials in
        try self.service.save(credentials: creds)
        return creds
      }

      switch newCredentialsResult {
      case let .failure(error):
        self.onError(error)

      case let .success(newCreds):
        self.beginSignIn(withCredentials: newCreds)
      }
    }
  }

  private func saveCredentials(_ newCreds: Credentials) {
    do {
      try service.save(credentials: newCreds)
    } catch {
      onError(error)
      return
    }
    authenticationComplete(withUser: newCreds.username, andToken: newCreds.token)
  }

  internal func logout() {
    do {
      try service.resetCredentials()
    } catch {
      onError(error)
      return
    }
    authenticationComplete(withUser: nil, andToken: nil)
  }

  private func signWithCredentials(_ credentials: Credentials) {
    service.beginRequest(
      SignInCreateRequest(
        body:
        .init(
          emailAddress: credentials.username,
          password: credentials.password
        )
      )
    ) { result in
      switch result {
      case let .failure(error):
        self.onError(error)

      case let .success(tokenContainer):
        let newCreds = credentials.withToken(tokenContainer.token)
        self.saveCredentials(newCreds)
      }
    }
  }

  private func receivedNewCredentials(_ newCreds: Credentials, isCreated: Bool) {
    switch (newCreds.token, isCreated) {
    case (.none, false):
      beginSignIn(withCredentials: newCreds)

    case (.some, _):
      saveCredentials(newCreds)

    case (.none, true):
      break
    }
  }

  private func beginRefreshToken(_ credentials: Credentials, _ createToken: Bool) {
    service.beginRequest(SignInRefreshRequest()) { [self] result in
      let newCredentialsResult: Result<Credentials, Error> = result.map { response in
        credentials.withToken(response.token)
      }
      .flatMapError { error in
        guard !createToken else {
          return .failure(error)
        }
        return .success(credentials.withoutToken())
      }
      let newCreds: Credentials
      switch newCredentialsResult {
      case let .failure(error):
        self.onError(error)
        return

      case let .success(credentials):
        newCreds = credentials
      }

      receivedNewCredentials(newCreds, isCreated: createToken)
    }
  }

  internal func beginSignIn(withCredentials credentials: Credentials) {
    let createToken = credentials.token == nil
    if createToken {
      signWithCredentials(credentials)
    } else {
      beginRefreshToken(credentials, createToken)
    }
  }

  private func authenticationComplete(
    withUser username: String?,
    andToken token: String?
  ) {
    Task { @MainActor in
      self.username = username
      self.token = token
    }
  }
}
