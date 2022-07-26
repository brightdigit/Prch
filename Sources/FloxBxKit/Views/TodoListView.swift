#if canImport(SwiftUI)
  import SwiftUI

  struct TodoListView: View {
    @EnvironmentObject var object: ApplicationObject

    var body: some View {
      List {
        ForEach(self.object.items) { item in
          TodoListItemView(item: item).onAppear { self.object.saveItem(item, onlyNew: true)
          }
        }.onDelete(perform: object.deleteItems(atIndexSet:))
      }
      .toolbar(content: {
        ToolbarItemGroup {
          HStack {

            Button {
              #if canImport(GroupActivities)
              if #available(iOS 15, *) {
                object.startSharing()
              } else {
                // Fallback on earlier versions
              }
              #endif
            } label: {
              Image(systemName: "shareplay")
            }

            Button {
              self.object.items.append(.init(title: "New Item"))
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

  struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
      TodoListView().environmentObject(ApplicationObject(items: [
        .init(title: "Do Stuff")
      ]))
    }
  }
#endif
