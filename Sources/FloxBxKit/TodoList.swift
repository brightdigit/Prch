#if canImport(SwiftUI)
  import SwiftUI

  struct TodoList: View {
    @EnvironmentObject var object: ApplicationObject

    var body: some View {
      List(self.object.items ?? .init()) { item in
        TodoListItemView(item: item)
      }
      .toolbar(content: {
        ToolbarItem(content: {
          Button {
            self.object.items?.append(.init(title: "New Item"))
          } label: {
            Image(systemName: "plus.circle.fill")
          }
        })
      })
      .navigationTitle("Todos")
    }
  }

  struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
      TodoList().environmentObject(ApplicationObject(items: [
        .init(title: "Do Stuff")
      ]))
    }
  }
#endif
