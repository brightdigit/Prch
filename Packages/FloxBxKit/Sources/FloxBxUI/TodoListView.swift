#if canImport(SwiftUI)
  import Combine
  import SwiftUI
import FloxBxNetworking
import FloxBxModels

  internal struct TodoListView: View {
    
//      @available(*, deprecated)
//    @EnvironmentObject private var object: ApplicationObject

    //@StateObject private var servicesObject : ServicesObject
    let onLogout : () -> Void
    let requestSharing : () -> Void
    @StateObject private var listObject : TodoListObject
    
    init (groupActivityID: UUID?, service: any AuthorizedService, items: [TodoContentItem] = [], isLoaded: Bool? = nil, onLogout: @escaping () -> Void, requestSharing : @escaping () -> Void) {
      let isLoaded = isLoaded ?? !items.isEmpty
      self.onLogout = onLogout
      self.requestSharing = requestSharing
      self._listObject = StateObject(wrappedValue: .init(groupActivityID: groupActivityID, service: service, isLoaded: isLoaded))
    }
    
    internal var body: some View {
      List {
        ForEach(self.listObject.items) { item in
          TodoListItemView(item: item, groupActivityID: listObject.groupActivityID, service: listObject.service).onAppear {
            self.listObject.saveItem(item, onlyNew: true)
          }
        }.onDelete(perform: listObject.beginDeleteItems(atIndexSet:))
      }

      .toolbar(content: {
        ToolbarItemGroup {
          HStack {
            Button {
              self.onLogout()
            } label: {
              Image(systemName: "person.crop.circle.fill.badge.xmark")
            }

            Button {
              #if canImport(GroupActivities)
                if #available(iOS 15, macOS 12, *) {
                  self.requestSharing()
                }
              #endif
            } label: {
              Image(systemName: "shareplay")
            }

            Button {
              self.listObject.addItem(.init(title: "New Item", tags: []))
            } label: {
              Image(systemName: "plus.circle.fill")
            }

            #if os(iOS)
              EditButton()
            #endif
          }
        }
      })
      .navigationTitle("Todos")
    }
  }

//  private struct TodoList_Previews: PreviewProvider {
//    // swiftlint:disable:next strict_fileprivate
//    fileprivate static var previews: some View {
//      TodoListView().environmentObject(
//        ApplicationObject(
//          mobileDevicePublisher: .init(
//            Just(.init(model: "", operatingSystem: "", topic: ""))
//          ),
//          [
//            .init(title: "Do Stuff", tags: ["things", "places"])
//          ]
//        )
//      )
//    }
//  }
#endif
