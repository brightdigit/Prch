// periphery:ignore
public protocol ClientBodyRequest: LegacyClientRequest
  where BodyType: Codable, SuccessType == Void {
  var body: BodyType { get }
}
