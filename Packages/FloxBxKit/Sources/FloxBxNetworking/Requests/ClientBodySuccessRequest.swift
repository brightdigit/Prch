public protocol ClientBodySuccessRequest: LegacyClientRequest
  where SuccessType: Codable, BodyType: Codable {
  var body: BodyType { get }
}
