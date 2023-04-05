public protocol ClientBodySuccessRequest: ClientRequest
  where SuccessType: Codable, BodyType: Codable {
  var body: BodyType { get }
}
