public protocol ClientSuccessRequest: LegacyClientRequest
  where SuccessType: Codable, BodyType == Void {}

extension ClientSuccessRequest {
  public var body: BodyType {
    ()
  }
}
