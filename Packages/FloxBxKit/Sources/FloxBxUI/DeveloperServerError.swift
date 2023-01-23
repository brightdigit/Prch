#if DEBUG

  internal enum DeveloperServerError: Error {
    case noServer
    case sublimationError(Error)
  }

#endif
