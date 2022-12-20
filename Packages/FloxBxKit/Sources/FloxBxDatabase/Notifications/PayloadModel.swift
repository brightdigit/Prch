import FloxBxModels

protocol PayloadModel: Codable {
  func asModel() -> Payload
}

extension TagPayload: PayloadModel {
  func asModel() -> Payload {
    .tag(self)
  }
}
