import FloxBxModeling
public protocol ClientSuccessRequest: ClientRequest
  where SuccessType: Codable, BodyType == Empty {}

extension ClientSuccessRequest {
  public var body: BodyType {
    return .value
  }
}
