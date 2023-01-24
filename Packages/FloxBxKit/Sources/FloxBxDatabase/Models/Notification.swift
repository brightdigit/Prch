import FloxBxModels
import Fluent
import Foundation

public final class Notification: Model {
  internal enum FieldKeys {
    internal static let mobileDeviceID: FieldKey = "mobileDeviceID"
    internal static let payload: FieldKey = "payload"
    internal static let createdAt: FieldKey = "created_at"
  }

  public static let schema = "Notification"

  @ID(custom: .id, generatedBy: .user)
  public var id: UUID?

  @Parent(key: FieldKeys.mobileDeviceID)
  public var mobileDevice: MobileDevice

  @Field(key: FieldKeys.payload)
  public var payload: Payload

  @Timestamp(key: FieldKeys.createdAt, on: .create)
  public var createdAt: Date?

  public init() {}

  public init(id: UUID, mobileDeviceID: MobileDevice.IDValue, payload: Payload) {
    self.id = id
    $mobileDevice.id = mobileDeviceID
    self.payload = payload
    createdAt = createdAt
  }
}

extension Notification {
  internal convenience init<PayloadType: PayloadModel>(
    id: UUID,
    deviceNotification: DeviceNotification<PayloadType>
  ) {
    self.init(
      id: id,
      mobileDeviceID: deviceNotification.deviceID,
      payload: deviceNotification.payloadNotification.payload.asModel()
    )
  }
}
