#if canImport(Combine)
  import Combine
  import FelinePine
  import FloxBxLogging
  import Foundation

  #if canImport(GroupActivities)
    import GroupActivities
  #endif

  public class SharePlayObject<
    DeltaType: Codable,
    ActivityConfigurationType,
    ActivityIDType: Hashable
  >: ObservableObject {
    @Published internal private(set) var listDeltas = [DeltaType]()
    @Published public private(set) var groupActivityID: ActivityIDType?
    @Published public private(set) var activity: ActivityIdentifiableContainer<
      ActivityIDType
    >?

    private let sharingRequestSubject =
      PassthroughSubject<ActivityConfigurationType, Never>()
    private let startSharingSubject = PassthroughSubject<Void, Never>()
    private let messageSubject =
      PassthroughSubject<[DeltaType], Never>()
    private var tasks = Set<Task<Void, Never>>()
    private var subscriptions = Set<AnyCancellable>()

    public var isEligible: Bool {
      #if canImport(GroupActivities)
        return groupState.isEligible
      #else
        return false
      #endif
    }

    #if canImport(GroupActivities)
      @Published private var session: GroupSessionContainer<ActivityIDType>?
      @Published private var groupState = GroupStateContainer()

      private lazy var messenger: Any? = nil

      @available(macOS 12, iOS 15, *)
      private var groupSessionMessenger: GroupSessionMessenger? {
        messenger as? GroupSessionMessenger
      }
    #endif

    public var messagePublisher: AnyPublisher<[DeltaType], Never> {
      messageSubject.eraseToAnyPublisher()
    }

    #if canImport(GroupActivities)
      @available(iOS 15, macOS 12, *)
      public init<ActivityType: SharePlayActivity>(_: ActivityType.Type)
        where ActivityType.ConfigurationType == ActivityConfigurationType,
        ActivityIDType == ActivityType.ID {
        $session.map { $0?.activityID }.assign(to: &$groupActivityID)

        sharingRequestSubject.map {
          ActivityType(configuration: $0)
        }
        .map { activity in
          Future { () -> Result<ActivityType, Error> in
            do {
              _ = try await activity.activate()
            } catch {
              return .failure(error)
            }
            return .success(activity)
          }
        }
        .switchToLatest()
        .compactMap {
          self.isEligible ? nil : try? $0.get()
        }
        .map(ActivityIdentifiableContainer.init(activity:))
        .receive(on: DispatchQueue.main)
        .assign(to: &$activity)
      }
    #endif

    public init() {}

    public static func createNew() -> SharePlayObject
      where ActivityIDType == UUID,
      ActivityConfigurationType == GroupActivityConfiguration {
      if #available(iOS 15, macOS 12, *) {
        #if canImport(GroupActivities)
          return .init(FloxBxActivity.self)
        #else
          return .init()
        #endif
      } else {
        return .init()
      }
    }

    #if canImport(GroupActivities)
      @available(iOS 15, macOS 12, *)
      public func configureGroupSession<ActivityType: SharePlayActivity>(
        _ groupSession: GroupSession<ActivityType>
      ) where ActivityType.ID == ActivityIDType {
        listDeltas = []

        session = .init(groupSession: groupSession)

        let messenger = GroupSessionMessenger(session: groupSession)
        self.messenger = messenger

        groupSession.$state
          .sink(receiveValue: { state in
            if case .invalidated = state {
              self.session = nil
              self.reset(ActivityType.self)
            }
          })
          .store(in: &subscriptions)

        groupSession.$activeParticipants
          .sink(receiveValue: { activeParticipants in
            let newParticipants = activeParticipants.subtracting(
              groupSession.activeParticipants
            )

            Self.logger.debug("New participants: \(newParticipants)")
            Task {
              do {
                try await messenger.send(self.listDeltas, to: .only(newParticipants))
              } catch {}
            }
          })
          .store(in: &subscriptions)
        let task = Task {
          for await(message, _) in messenger.messages(of: [DeltaType].self) {
            messageSubject.send(message)
          }
        }
        tasks.insert(task)

        groupSession.join()
      }

      public func beginRequest(
        forConfiguration configuration: ActivityConfigurationType
      ) {
        sharingRequestSubject.send(configuration)
      }

      @available(macOS 12, iOS 15, *)
      private func getGroupSession<
        ActivityType: SharePlayActivity
      >(
        _: ActivityType.Type
      ) -> GroupSession<ActivityType>?
        where ActivityType.ID == ActivityIDType {
        session?.getGroupSession()
      }

      @available(macOS 12, iOS 15, *)
      public func getSessions<
        ActivityType: SharePlayActivity
      >(
        _: ActivityType.Type
      ) -> GroupSession<ActivityType>.Sessions {
        ActivityType.sessions()
      }

      @available(macOS 12, iOS 15, *)
      public func listenForSessions<
        ActivityType: SharePlayActivity
      >(
        forActivity _: ActivityType.Type
      ) async where ActivityType.ID == ActivityIDType {
        for await session in getSessions(ActivityType.self) {
          configureGroupSession(session)
        }
      }
    #endif

    #if canImport(GroupActivities)
      @available(iOS 15, macOS 12, *)
      private func reset<
        ActivityType: SharePlayActivity
      >(
        _ activityType: ActivityType.Type
      ) where ActivityType.ID == ActivityIDType {
        listDeltas = []
        messenger = nil
        tasks.forEach { $0.cancel() }
        tasks = []
        subscriptions = []
        if let groupSession = getGroupSession(activityType) {
          groupSession.leave()
          session = nil
          startSharingSubject.send()
        }
      }
    #endif

    public func send(_ deltas: [DeltaType]) {
      Self.logger.debug("Receiving deltas: \(deltas)")
      #if canImport(GroupActivities)
        if #available(iOS 15, macOS 12, *) {
          if let groupSessionMessenger = self.groupSessionMessenger {
            Task {
              do {
                try await groupSessionMessenger.send(deltas)
              } catch {}
            }
          }
        }
      #endif
    }

    public func append(delta: DeltaType) {
      DispatchQueue.main.async {
        self.listDeltas.append(delta)
      }
    }
  }

  extension SharePlayObject: LoggerCategorized {
    public typealias LoggersType = FloxBxLogging.Loggers

    public static var loggingCategory: FloxBxLogging.LoggerCategory {
      .shareplay
    }
  }
#endif
