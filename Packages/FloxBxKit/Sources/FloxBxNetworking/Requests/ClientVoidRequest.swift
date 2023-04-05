import FloxBxModeling
public protocol ClientVoidRequest: ClientRequest
  where BodyType == Empty, SuccessType == Empty {}

extension ClientVoidRequest {
  public var body: BodyType {
    return .value
  }
}
