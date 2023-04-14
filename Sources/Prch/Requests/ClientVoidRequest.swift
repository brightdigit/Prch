import PrchModel
public protocol ClientVoidRequest: ClientRequest
  where BodyType == Empty, SuccessType == Empty {}

extension ClientVoidRequest {
  public var body: BodyType {
    .value
  }
}