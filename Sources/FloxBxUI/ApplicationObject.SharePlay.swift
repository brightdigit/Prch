import FloxBxGroupActivities
import FloxBxModels
import Foundation

#if canImport(GroupActivities) && canImport(Combine) && canImport(SwiftUI)
  import GroupActivities

  extension ApplicationObject {
    @available(iOS 15, macOS 12, *)
    func startSharing() {
      Task {
        do {
          guard let username = username else {
            return
          }

          let groupSession = try await self.service.request(CreateGroupSessionRequest())
          _ = try await self.shareplayObject.activity(forGroupSessionWithID: groupSession.id, withUserName: username)
          //
        } catch {
          print("Failed to activate ShoppingListActivity activity: \(error)")
        }
      }
    }

    func handle(_ deltas: [TodoListDelta]) {
      for delta in deltas {
        handle(delta)
      }
    }

    func handle(_ delta: TodoListDelta) {
      switch delta {
      case let .upsert(id, content):

        let index = items.firstIndex { item in
          item.serverID == id
        }
        if let index = index {
          DispatchQueue.main.async {
            self.items[index] = self.items[index].updatingTitle(content.title)
          }
        } else {
          DispatchQueue.main.async {
            self.items.append(.init(serverID: id, title: content.title))
          }
        }

      case let .remove(ids):
        let indicies = ids.compactMap { id in
          self.items.firstIndex { item in
            item.serverID == id
          }
        }

        DispatchQueue.main.async {
          self.items.remove(atOffsets: IndexSet(indicies))
        }
      }

      shareplayObject.append(delta: delta)
    }
  }

#endif
