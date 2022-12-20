#if DEBUG

  enum DeveloperServerError: Error {
    case noServer
    case sublimationError(Error)
  }

#endif
