#if canImport(SwiftUI)
  import FloxBxGroupActivities
  import SwiftUI

  struct ContentView: View {
    init() {}

    @EnvironmentObject var object: ApplicationObject
    #if canImport(GroupActivities)
      @State var activity: ActivityIdentifiableContainer<UUID>?
    #endif
    var innerView: some View {
      let view = TodoListView()
      #if os(macOS)
        return view.frame(width: 500, height: 500)
      #else
        return view
      #endif
    }

    var mainView: some View {
      TabView {
        NavigationView {
          if #available(iOS 15.0, watchOS 8.0, macOS 12, *) {
            #if canImport(GroupActivities)
              innerView.task {
                for await session in self.object.shareplayObject.getSessions(FloxBxActivity.self) {
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
      })
    }

    var body: some View {
      if #available(iOS 15.4, *) {
        #if canImport(GroupActivities)
          mainView.sheet(item: self.$activity) { activity in
            GroupActivitySharingView<FloxBxActivity>(activity: activity.getGroupActivity())
          }.onReceive(self.object.shareplayObject.$activity, perform: { activity in
            self.activity = activity
          })
          .onAppear(perform: {
            self.object.begin()
          })

        #else
          mainView.onAppear(perform: {
            self.object.begin()
          })
        #endif
      } else {
        mainView.onAppear(perform: {
          self.object.begin()
        })
      }
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
#endif
