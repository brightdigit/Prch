import FloxBxAuth
import FloxBxGroupActivities
import FloxBxModels
import FloxBxNetworking
import Sublimation

#if canImport(Combine) && canImport(SwiftUI) && canImport(UserNotifications)
  import Combine
  import SwiftUI
  import UserNotifications

  internal class ApplicationObject: ObservableObject {
    @Published internal private(set) var shareplayObject: SharePlayObject<
      TodoListDelta, GroupActivityConfiguration, UUID
    >

    private var cancellables = [AnyCancellable]()

    private let mobileDevicePublisher: AnyPublisher<CreateMobileDeviceRequestContent?, Never>
    @AppStorage("MobileDeviceRegistrationID") private var mobileDeviceRegistrationID: String?
    @Published internal private(set) var requiresAuthentication: Bool
    @Published internal private(set) var latestError: Error?
    @Published internal private(set) var token: String?
    @Published internal private(set) var username: String?
    @Published internal private(set) var items = [TodoContentItem]()

    #if DEBUG
      private var service: Service!
    #else
      private let service: Service = ServiceImpl(
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
      if #available(iOS 15, macOS 12, *) {
        #if canImport(GroupActivities)
          self.shareplayObject = .init(FloxBxActivity.self)
        #else
          self.shareplayObject = .init()
        #endif
      } else {
        shareplayObject = .init()
      }
      requiresAuthentication = true
      let authenticated = $token.map { $0 == nil }
      authenticated.print().receive(on: DispatchQueue.main).assign(to: &$requiresAuthentication)

      let groupSessionIDPub = shareplayObject.$groupActivityID

      $token
        .share()
        .compactMap { $0 }
        .combineLatest(groupSessionIDPub)
        .map(\.1)
        .flatMap { groupActivityID in
          Future { closure in
            self.service.beginRequest(
              GetTodoListRequest(groupActivityID: groupActivityID)
            ) { result in
              closure(result)
            }
          }
        }
        .map { content in
          content.map(TodoContentItem.init)
        }
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

    internal func addDelta(_ delta: TodoListDelta) {
      shareplayObject.send([delta])
    }

    fileprivate func setupCredentials() {
      let credentials: Credentials?
      let error: Error?
      do {
        credentials = try service.fetchCredentials()
        error = nil
      } catch let caughtError {
        error = caughtError
        credentials = nil
      }

      DispatchQueue.main.async {
        self.latestError = self.latestError ?? error
      }

      if let credentials = credentials {
        beginSignIn(withCredentials: credentials)
      } else {
        DispatchQueue.main.async {
          self.requiresAuthentication = true
        }
      }
    }

    #if DEBUG
      fileprivate func fetchBaseURL() async throws -> URL {
        do {
          guard let url = try await KVdb.url(
            withKey: Configuration.Sublimation.key,
            atBucket: Configuration.Sublimation.bucketName
          ) else {
            throw DeveloperServerError.noServer
          }
          return url
        } catch {
          throw DeveloperServerError.sublimationError(error)
        }
      }

      fileprivate func developerService() async -> Service {
        let baseURL: URL
        do {
          baseURL = try await fetchBaseURL()
          debugPrint("Found BaseURL: \(baseURL)")
        } catch {
          await MainActor.run {
            self.latestError = error
          }
          baseURL = URL(string: "https://apple.com")!
        }
        return ServiceImpl(
          baseURL: baseURL,
          accessGroup: Configuration.accessGroup,
          serviceName: Configuration.serviceName
        )
      }
    #endif

    internal func begin() {
      Task {
        #if DEBUG
          self.service = await developerService()
        #endif

        self.mobileDevicePublisher.flatMap { content in
          Future { () -> UUID? in
            let id = self.mobileDeviceRegistrationID.flatMap(UUID.init(uuidString:))
            switch (content, id) {
            case let (.some(content), .some(id)):
              do {
                try await self.service.request(PatchMobileDeviceRequest(id: id, body: .init(createContent: content)))
              } catch let RequestError.invalidStatusCode(statusCode) where statusCode == 404 {
                return try await self.service.request(CreateMobileDeviceRequest(body: content)).id
              } catch {
                throw error
              }
              return id

            case let (.some(content), .none):
              return try await self.service.request(CreateMobileDeviceRequest(body: content)).id

            case (nil, let .some(id)):
              try await self.service.request(DeleteMobileDeviceRequest(id: id))
              return nil

            case (nil, nil):
              debugPrint("ERROR: invalid state")
              return nil
            }
          }
        }
        .replaceError(with: nil)
        .compactMap { $0?.uuidString }
        .receive(on: DispatchQueue.main)
        .sink { id in
          self.mobileDeviceRegistrationID = id
        }.store(in: &self.cancellables)
        let isNotificationAuthorizationGrantedResult = await Result {
          try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.sound, .badge, .alert])
        }
        // UNUserNotificationCenter.current().notificationSettings()
        Task { @MainActor in
          switch isNotificationAuthorizationGrantedResult {
          case .success(true):
            await AppInterfaceObject.sharedInterface.registerForRemoteNotifications()

          case .success(false):
            await AppInterfaceObject.sharedInterface.unregisterForRemoteNotifications()

          case let .failure(error):
            debugPrint(error)
          }
        }

        setupCredentials()
      }
    }

    internal func saveItem(_ item: TodoContentItem, onlyNew: Bool = false) {
      guard let index = items.firstIndex(where: { $0.id == item.id }) else {
        return
      }

      guard !(item.isSaved && onlyNew) else {
        return
      }

      let content = CreateTodoRequestContent(title: item.title, tags: item.tags)
      let request = UpsertTodoRequest(
        groupActivityID: shareplayObject.groupActivityID,
        itemID: item.serverID,
        body: content
      )

      service.beginRequest(request) { todoItemResult in
        switch todoItemResult {
        case let .success(todoItem):

          DispatchQueue.main.async {
            self.addDelta(.upsert(todoItem.id, content))

            self.items[index] = .init(content: todoItem)
          }

        case let .failure(error):

          DispatchQueue.main.async {
            self.latestError = error
          }
        }
      }
    }

    private func beginDeleteItems(
      atIndexSet indexSet: IndexSet,
      _ completed: @escaping (Error?) -> Void
    ) {
      let savedIndexSet = indexSet.filteredIndexSet(includeInteger: { items[$0].isSaved })

      let deletedIds = Set(savedIndexSet.compactMap {
        items[$0].serverID
      })

      guard !deletedIds.isEmpty else {
        DispatchQueue.main.async {
          completed(nil)
        }
        return
      }

      addDelta(.remove(Array(deletedIds)))

      let group = DispatchGroup()

      var errors = [Error?].init(repeating: nil, count: deletedIds.count)
      for (index, id) in deletedIds.enumerated() {
        group.enter()
        let request = DeleteTodoItemRequest(
          itemID: id, groupActivityID: shareplayObject.groupActivityID
        )
        service.beginRequest(request) { error in
          errors[index] = error
          group.leave()
        }
      }
      group.notify(queue: .main) {
        completed(errors.compactMap { $0 }.last)
      }
    }

    internal func deleteItems(
      atIndexSet indexSet: IndexSet
    ) {
      beginDeleteItems(atIndexSet: indexSet) { error in
        self.items.remove(atOffsets: indexSet)
        self.latestError = error
      }
    }

    internal func beginSignup(withCredentials credentials: Credentials) {
      service.beginRequest(
        SignUpRequest(
          body: .init(
            emailAddress: credentials.username,
            password: credentials.password
          )
        )
      ) { result in
        let newCredentialsResult = result.map { content in
          credentials.withToken(content.token)
        }
        .tryMap { creds -> Credentials in
          try self.service.save(credentials: creds)
          return creds
        }

        switch newCredentialsResult {
        case let .failure(error):
          DispatchQueue.main.async {
            self.latestError = error
          }

        case let .success(newCreds):
          self.beginSignIn(withCredentials: newCreds)
        }
      }
    }

    private func saveCredentials(_ newCreds: Credentials) {
      do {
        try service.save(credentials: newCreds)
      } catch {
        latestError = error
        return
      }
      DispatchQueue.main.async {
        self.username = newCreds.username
        self.token = newCreds.token
      }
    }

    internal func logout() {
      do {
        try service.resetCredentials()
      } catch {
        latestError = error
        return
      }
      DispatchQueue.main.async {
        self.username = nil
        self.token = nil
      }
    }

    private func signWithCredentials(_ credentials: Credentials) {
      service.beginRequest(
        SignInCreateRequest(
          body:
          .init(
            emailAddress: credentials.username,
            password: credentials.password
          )
        )
      ) { result in
        switch result {
        case let .failure(error):
          DispatchQueue.main.async {
            self.latestError = error
          }

        case let .success(tokenContainer):
          let newCreds = credentials.withToken(tokenContainer.token)
          self.saveCredentials(newCreds)
        }
      }
    }

    private func receivedNewCredentials(_ newCreds: Credentials, isCreated: Bool) {
      switch (newCreds.token, isCreated) {
      case (.none, false):
        beginSignIn(withCredentials: newCreds)

      case (.some, _):
        saveCredentials(newCreds)

      case (.none, true):
        break
      }
    }

    private func beginRefreshToken(_ credentials: Credentials, _ createToken: Bool) {
      service.beginRequest(SignInRefreshRequest()) { [self] result in
        let newCredentialsResult: Result<Credentials, Error> = result.map { response in
          credentials.withToken(response.token)
        }
        .flatMapError { error in
          guard !createToken else {
            return .failure(error)
          }
          return .success(credentials.withoutToken())
        }
        let newCreds: Credentials
        switch newCredentialsResult {
        case let .failure(error):
          DispatchQueue.main.async {
            self.latestError = error
          }
          return

        case let .success(credentials):
          newCreds = credentials
        }

        receivedNewCredentials(newCreds, isCreated: createToken)
      }
    }

    internal func beginSignIn(withCredentials credentials: Credentials) {
      let createToken = credentials.token == nil
      if createToken {
        signWithCredentials(credentials)
      } else {
        beginRefreshToken(credentials, createToken)
      }
    }

    internal func addItem(_ item: TodoContentItem) {
      DispatchQueue.main.async {
        self.items.append(item)
      }
    }

    internal func removeItems(atOffsets offsets: IndexSet) {
      DispatchQueue.main.async {
        self.items.remove(atOffsets: offsets)
      }
    }

    internal func updateItem(at index: Int, with item: TodoContentItem) {
      DispatchQueue.main.async {
        self.items[index] = item
      }
    }

    internal func createGroupSession() async throws -> CreateGroupSessionResponseContent {
      try await service.request(CreateGroupSessionRequest())
    }
  }
#endif
