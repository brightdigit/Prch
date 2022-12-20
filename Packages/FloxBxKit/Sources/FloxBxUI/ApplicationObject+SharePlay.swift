import FloxBxGroupActivities
import FloxBxModels
import Foundation

#if canImport(GroupActivities) && canImport(Combine) && canImport(SwiftUI)
  import GroupActivities

  extension ApplicationObject {
    @available(iOS 15, macOS 12, *)
    internal func requestSharing() {
      Task {
        do {
          guard let username = username else {
            return
          }

          let groupSession = try await self.createGroupSession()
          self.shareplayObject
            .beginRequest(
              forConfiguration: .init(
                groupActivityID: groupSession.id,
                username: username
              )
            )
          //
        } catch {
          print("Failed to activate ShoppingListActivity activity: \(error)")
        }
      }
    }

    internal func handle(_ deltas: [TodoListDelta]) {
      for delta in deltas {
        handle(delta)
      }
    }

    private func handle(_ delta: TodoListDelta) {
      switch delta {
      case let .upsert(id, content):

        let index = items.firstIndex { item in
          item.serverID == id
        }
        if let index = index {
          DispatchQueue.main.async {
            self.updateItem(
              at: index,
              with: self.items[index].updatingTitle(content.title, tags: content.tags)
            )
          }
        } else {
          DispatchQueue.main.async {
            self.addItem(.init(title: content.title, tags: content.tags, serverID: id))
          }
        }

      case let .remove(ids):
        let indicies = ids.compactMap { id in
          self.items.firstIndex { item in
            item.serverID == id
          }
        }

        DispatchQueue.main.async {
          self.removeItems(atOffsets: IndexSet(indicies))
        }
      }

      shareplayObject.append(delta: delta)
    }
  }

#endif
