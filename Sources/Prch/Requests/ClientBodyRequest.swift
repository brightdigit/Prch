import PrchModel
public protocol ClientBodyRequest: ClientRequest
  where BodyType: Codable, SuccessType == Empty {
  var body: BodyType { get }
}