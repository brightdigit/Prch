#if canImport(Combine)

  import Combine
  import Foundation

  extension Future where Failure == Never {
    public convenience init(_ asyncFunc: @escaping () async -> Output) {
      self.init { promise in
        Task {
          promise(.success(await asyncFunc()))
        }
      }
    }
  }

  extension Future where Failure == Error {
    public convenience init(_ asyncFunc: @escaping () async throws -> Output) {
      self.init { promise in
        Task {
          let success: Output
          do {
            success = try await asyncFunc()
          } catch {
            promise(.failure(error))
            return
          }
          promise(.success(success))
        }
      }
    }
  }

#endif
