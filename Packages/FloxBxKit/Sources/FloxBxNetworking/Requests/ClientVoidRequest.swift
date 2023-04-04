public protocol ClientVoidRequest: LegacyClientRequest
  where BodyType == Void, SuccessType == Void {}

extension ClientVoidRequest {
  public var body: BodyType {
    ()
  }
}
