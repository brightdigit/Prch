import Foundation

import Combine
import Foundation

public extension Future where Failure == Never {
  convenience init(_ asyncFunc: @escaping () async -> Output) {
    self.init { promise in
      Task {
        promise(.success(await asyncFunc()))
      }
    }
  }
}
