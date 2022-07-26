public protocol ClientVoidRequest: ClientRequest where BodyType == Void, SuccessType == Void {}

public extension ClientVoidRequest {
  var body: BodyType {
    ()
  }
}
