#if canImport(Combine)
  import Combine

  extension Publisher {
    public func mapEach<T>(
      _ transform: @escaping (Output.Element) -> T
    ) -> Publishers.Map<Self, [T]> where Output: Sequence {
      map { sequence in
        sequence.map(transform)
      }
    }
  }
#endif
