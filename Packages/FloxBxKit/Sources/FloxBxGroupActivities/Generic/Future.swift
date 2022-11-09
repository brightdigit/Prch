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

#endif
