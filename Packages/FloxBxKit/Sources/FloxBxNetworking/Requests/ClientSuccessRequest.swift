public protocol ClientSuccessRequest: ClientRequest
  where SuccessType: Codable, BodyType == Void {}

extension ClientSuccessRequest {
  public var body: BodyType {
    ()
  }
}
