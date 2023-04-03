// periphery:ignore
@available(*, deprecated)
public protocol ClientBodyRequest: ClientRequest
  where BodyType: Codable, SuccessType == Void {
  var body: BodyType { get }
}
