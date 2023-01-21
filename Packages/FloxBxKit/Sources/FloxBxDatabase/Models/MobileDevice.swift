import Fluent
import Foundation

public final class MobileDevice: Model {
  internal enum FieldKeys {
    internal static let model: FieldKey = "model"
    internal static let operatingSystem: FieldKey = "operatingSystem"
    internal static let deviceToken: FieldKey = "deviceToken"
    internal static let userID: FieldKey = "userID"
    internal static let topic: FieldKey = "topic"
  }

  public static let schema = "MobileDevices"

  @ID(key: .id)
  public var id: UUID?

  @Field(key: FieldKeys.model)
  public var model: String

  @Field(key: FieldKeys.operatingSystem)
  public var operatingSystem: String

  @Field(key: FieldKeys.topic)
  public var topic: String

  @Field(key: FieldKeys.deviceToken)
  public var deviceToken: Data?

  @Parent(key: FieldKeys.userID)
  public var user: User

  public init() {}

  public init(
    id: UUID? = nil,
    model: String,
    operatingSystem: String,
    topic: String,
    deviceToken: Data? = nil
  ) {
    self.id = id
    self.model = model
    self.operatingSystem = operatingSystem
    self.topic = topic
    self.deviceToken = deviceToken
  }
}
