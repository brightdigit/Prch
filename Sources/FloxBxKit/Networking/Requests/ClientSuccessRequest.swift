public protocol ClientSuccessRequest: ClientRequest where SuccessType: Codable, BodyType == Void {}

public extension ClientSuccessRequest {
  var body: BodyType {
    ()
  }
}
