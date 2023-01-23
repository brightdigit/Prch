import FloxBxModels

internal protocol PayloadModel: Codable {
  func asModel() -> Payload
}

extension TagPayload: PayloadModel {
  internal func asModel() -> Payload {
    .tag(self)
  }
}
