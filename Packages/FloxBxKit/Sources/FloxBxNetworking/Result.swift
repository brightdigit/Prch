extension Result {
  public func tryMap<NewSuccess>(
    _ transform: @escaping (Success) throws -> (NewSuccess)
  ) -> Result<NewSuccess, Error> {
    let oldValue: Success
    let newValue: NewSuccess
    switch self {
    case let .success(value):
      oldValue = value

    case let .failure(error):
      return .failure(error)
    }
    do {
      newValue = try transform(oldValue)
    } catch {
      return .failure(error)
    }
    return .success(newValue)
  }

  public func asError() -> Failure? where Success == Void {
    guard case let .failure(error) = self else {
      return nil
    }
    return error
  }

  public func transform<NewSuccess>(
    _ transform: @autoclosure () -> NewSuccess
  ) -> Result<NewSuccess, Failure> {
    map { _ in
      transform()
    }
  }

  public func asVoid() -> Result<Void, Failure> {
    transform(())
  }

  public init(_ asyncFunc: @escaping () async throws -> Success) async where Failure == Error {
    let success: Success
    do {
      success = try await asyncFunc()
    } catch {
      self = .failure(error)
      return
    }
    self = .success(success)
  }
}
