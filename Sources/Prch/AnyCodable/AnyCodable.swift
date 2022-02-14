import Foundation

@available(*, deprecated, renamed: "AnyCodable")
public typealias CodableAny = AnyCodable

public struct AnyCodable {
  let value: Any

  init<T>(_ value: T?) {
    self.value = value ?? ()
  }
}
