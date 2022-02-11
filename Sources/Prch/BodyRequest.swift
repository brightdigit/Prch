import Foundation

public protocol BodyRequest: ServiceRequest {
  associatedtype Body: Encodable
  var body: Body { get }
}

public extension BodyRequest {
  var encodeBody: ((RequestEncoder) throws -> Data)? {
    { defaultEncoder in
      try defaultEncoder.encode(body)
    }
  }
}
