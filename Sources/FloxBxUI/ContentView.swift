#if canImport(SwiftUI)
  import FloxBxGroupActivities
  import SwiftUI

  struct ContentView: View {
    init() {}

    @EnvironmentObject var object: ApplicationObject

    var innerView: some View {
      let view = TodoListView()
      #if os(macOS)
        return view.frame(width: 500, height: 500)
      #else
        return view
      #endif
    }

    var body: some View {
      TabView {
        NavigationView {
          if #available(iOS 15.0, watchOS 8.0, macOS 12, *) {
            #if canImport(GroupActivities)
              innerView.task {
                for await session in self.object.shareplayObject.sessions() {
                  self.object.shareplayObject.configureGroupSession(session)
                }
              }
            #else
              innerView
            #endif
          } else {
            innerView
          }
        }
      }
      .sheet(isPresented: self.$object.requiresAuthentication, content: {
        LoginView()
      }).onAppear(perform: {
        self.object.begin()
      })
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
#endif
