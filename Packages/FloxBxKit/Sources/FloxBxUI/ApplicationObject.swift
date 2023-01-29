import FelinePine
import FloxBxAuth
import FloxBxGroupActivities
import FloxBxLogging
import FloxBxModels
import FloxBxNetworking
import FloxBxUtilities
import Sublimation

#if canImport(Combine) && canImport(SwiftUI) && canImport(UserNotifications)
  import Combine
  import SwiftUI
  import UserNotifications

  @available(*, deprecated)
  internal class ApplicationObject: ObservableObject, LoggerCategorized {
    internal typealias LoggersType = FloxBxLogging.Loggers

    internal typealias CredentialsService =
      ServiceImpl<JSONCoder, URLSession, URLRequestBuilder, KeychainContainer>

    internal static var loggingCategory: LoggerCategory {
      LoggerCategory.reactive
    }

    @Published internal private(set) var shareplayObject: SharePlayObject<
      TodoListDelta, GroupActivityConfiguration, UUID
    >

    internal var cancellables = [AnyCancellable]()

    // swiftlint:disable:next line_length
    internal let mobileDevicePublisher: AnyPublisher<CreateMobileDeviceRequestContent?, Never>
    @AppStorage("MobileDeviceRegistrationID")
    internal private(set) var mobileDeviceRegistrationID: String?
    @Published internal var requiresAuthentication: Bool
    @Published internal private(set) var latestError: Error?
    @Published internal var token: String?
    @Published internal var username: String?
    @Published internal var items = [TodoContentItem]()

    #if DEBUG
      // swiftlint:disable:next implicitly_unwrapped_optional
      internal var service: CredentialsService!
    #else
      internal let service: Service = ServiceImpl(
        baseURL: Configuration.productionBaseURL,
        accessGroup: Configuration.accessGroup,
        serviceName: Configuration.serviceName
      )
    #endif

    internal init(
      mobileDevicePublisher: AnyPublisher<CreateMobileDeviceRequestContent?, Never>,
      _ items: [TodoContentItem] = []
    ) {
      self.mobileDevicePublisher = mobileDevicePublisher
      shareplayObject = .createNew()
      requiresAuthentication = true

      $token
        .map { $0 == nil }
        .receive(on: DispatchQueue.main)
        .assign(to: &$requiresAuthentication)

      let groupSessionIDPub = shareplayObject.$groupActivityID

      $token
        .share()
        .compactMap { $0 }
        .combineLatest(groupSessionIDPub)
        .map(\.1)
        .flatMap(getTodoListFrom)
        .mapEach(TodoContentItem.init)
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .assign(to: &$items)

      if #available(iOS 15, macOS 12, *) {
        #if canImport(GroupActivities)
          self.shareplayObject.messagePublisher
            .sink(receiveValue: self.handle(_:))
            .store(in: &self.cancellables)
        #endif
      }

      self.items = items
    }

    private func setupServices() async {
      service = await developerService(
        fallbackURL: Configuration.productionBaseURL
      )
    }

    internal func begin() {
      Task {
        #if DEBUG
          await setupServices()
        #endif

        await setupNotifications()

        setupCredentials()
      }
    }

    internal func onError(_ error: Error) {
      Task { @MainActor in
        self.latestError = error
      }
    }

    internal func updateMobileDeviceRegistrationID(
      _ updateMobileDeviceRegistrationID: String
    ) {
      mobileDeviceRegistrationID = updateMobileDeviceRegistrationID
    }
  }

#endif
