import Foundation

public protocol RequestEncoder {
  func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: RequestEncoder {}
