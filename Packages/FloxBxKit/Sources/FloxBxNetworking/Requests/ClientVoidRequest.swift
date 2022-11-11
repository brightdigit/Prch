public protocol ClientVoidRequest: ClientRequest
  where BodyType == Void, SuccessType == Void {}

extension ClientVoidRequest {
  public var body: BodyType {
    ()
  }
}
