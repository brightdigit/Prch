import FloxBxDatabase
import FloxBxModels
import Foundation
import RouteGroups
import Vapor

extension MobileDevice {
  convenience init(content: CreateMobileDeviceRequestContent) {
    self.init(
      model: content.model,
      operatingSystem: content.operatingSystem,
      topic: content.topic,
      deviceToken: content.deviceToken
    )
  }

  func patch(content: PatchMobileDeviceRequestContent) {
    deviceToken = content.deviceToken ?? deviceToken
    operatingSystem = content.operatingSystem ?? operatingSystem
    model = content.model ?? model
    topic = content.topic ?? topic
  }
}

extension CreateMobileDeviceResponseContent: Content {}

struct MobileDeviceController: RouteGroupCollection {
  var routeGroups: [RouteGroupKey: RouteGroups.RouteCollectionBuilder] {
    [
      .bearer: { bearer in
        bearer.post("device", "mobile", use: self.create(from:))
        bearer.patch("device", "mobile", ":deviceID", use: self.patch(from:))
        bearer.delete("device", "mobile", ":deviceID", use: self.delete(from:))
      }
    ]
  }

  typealias RouteGroupKeyType = RouteGroupKey

  func create(from request: Request) async throws -> CreateMobileDeviceResponseContent {
    let user = try request.auth.require(User.self)
    let content = try request.content.decode(CreateMobileDeviceRequestContent.self)
    let device = MobileDevice(content: content)
    try await user.$mobileDevices.create(device, on: request.db)
    return try .init(id: device.requireID())
  }

  func patch(from request: Request) async throws -> HTTPStatus {
    let user = try request.auth.require(User.self)
    let deviceID = try request.parameters.require("deviceID", as: UUID.self)
    let content: PatchMobileDeviceRequestContent = try request.content.decode(PatchMobileDeviceRequestContent.self)
    let device = try await user.$mobileDevices.query(on: request.db).filter(.id, .equality(inverse: false), deviceID).first()

    guard let device = device else {
      throw Abort(.notFound)
    }

    device.patch(content: content)

    try await device.update(on: request.db)

    return .noContent
  }

  func delete(from request: Request) async throws -> HTTPStatus {
    let user = try request.auth.require(User.self)
    let deviceID: UUID = try request.parameters.require("deviceID")
    let device = try await user.$mobileDevices.query(on: request.db).filter(.id, .equality(inverse: false), deviceID).first()

    guard let device = device else {
      throw Abort(.notFound)
    }
    try await device.delete(on: request.db)
    return .noContent
  }
}
