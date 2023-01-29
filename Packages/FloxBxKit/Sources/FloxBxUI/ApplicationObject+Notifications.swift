import Combine
import FloxBxModels
import FloxBxNetworking
import FloxBxRequests
import Foundation
import UserNotifications

extension ApplicationObject {
  internal func setupNotifications() async {
    mobileDevicePublisher.flatMap { content in
      Future { [self] () -> UUID? in
        try await upsertMobileDevice(basedOn: content)
      }
    }
    .replaceError(with: nil)
    .compactMap { $0?.uuidString }
    .receive(on: DispatchQueue.main)
    .sink(receiveValue: updateMobileDeviceRegistrationID)
    .store(in: &cancellables)

    await updateRegistrationUpdateWith(
      UNUserNotificationCenter.current(),
      using: await AppInterfaceObject.sharedInterface
    )
  }

  private func upsertMobileDevice(
    basedOn content: CreateMobileDeviceRequestContent?
  ) async throws -> UUID? {
    let id = mobileDeviceRegistrationID.flatMap(UUID.init(uuidString:))
    switch (content, id) {
    case let (.some(content), .some(id)):
      do {
        try await service.request(
          PatchMobileDeviceRequest(id: id, body: .init(createContent: content))
        )
      } catch let RequestError.invalidStatusCode(statusCode) where statusCode == 404 {
        return try await service.request(CreateMobileDeviceRequest(body: content)).id
      } catch {
        throw error
      }
      return id

    case let (.some(content), .none):
      return try await service.request(CreateMobileDeviceRequest(body: content)).id

    case (nil, let .some(id)):
      try await service.request(DeleteMobileDeviceRequest(id: id))
      return nil

    case (nil, nil):
      Self.logger.error("Invalid Mobile Device State")
      return nil
    }
  }

  private func updateRegistrationUpdateWith(
    _ notificationCenter: UNUserNotificationCenter,
    using sharedInterace: @escaping @autoclosure () async -> AppInterface
  ) async {
    let isNotificationAuthorizationGrantedResult = await Result {
      try await notificationCenter
        .requestAuthorization(options: [.sound, .badge, .alert])
    }

    Task { @MainActor in
      switch isNotificationAuthorizationGrantedResult {
      case .success(true):
        await sharedInterace().registerForRemoteNotifications()

      case .success(false):
        await sharedInterace().unregisterForRemoteNotifications()

      case let .failure(error):
        debugPrint(error)
      }
    }
  }
}
