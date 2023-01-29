#if canImport(Combine) && canImport(SwiftUI) && canImport(UserNotifications)
  import Combine
  import Foundation
  import UserNotifications

  import Sublimation

  import FloxBxAuth
  import FloxBxGroupActivities
  import FloxBxModels
  import FloxBxNetworking
  import FloxBxRequests
  import FloxBxUtilities

  extension ApplicationObject {
    internal func addDelta(_ delta: TodoListDelta) {
      shareplayObject.send([delta])
    }

    internal func getTodoListFrom(
      _ groupActivityID: UUID?
    ) -> Future<GetTodoListRequest.SuccessType, Error> {
      Future { closure in
        self.service.beginRequest(
          GetTodoListRequest(groupActivityID: groupActivityID)
        ) { result in
          closure(result)
        }
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
            // self.addDelta(.upsert(todoItem.id, content))

            self.items[index] = .init(content: todoItem)
          }

        case let .failure(error):

          self.onError(error)
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

      addDelta(.remove(deletedIds))
      // addDelta(.remove(Array(deletedIds)))

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
        if let error = error {
          self.onError(error)
        }
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
