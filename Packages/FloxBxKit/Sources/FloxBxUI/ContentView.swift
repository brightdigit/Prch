#if canImport(SwiftUI)
  import FloxBxGroupActivities
  import SwiftUI

  internal struct ContentView: View {
    @EnvironmentObject private var object: ApplicationObject

    #if canImport(GroupActivities)
      @State private var activity: ActivityIdentifiableContainer<UUID>?
    #endif

    @State private var shouldDisplayLoginView: Bool = false

    private var innerView: some View {
      let view = TodoListView()
      #if os(macOS)
        return view.frame(width: 500, height: 500)
      #else
        return view
      #endif
    }

    private var mainView: some View {
      TabView {
        NavigationView {
          if #available(iOS 15.0, watchOS 8.0, macOS 12, *) {
            #if canImport(GroupActivities)
              innerView.task {
                await self.object.shareplayObject
                  .listenForSessions(forActivity: FloxBxActivity.self)
              }
            #else
              innerView
            #endif
          } else {
            innerView
          }
        }
      }
      .sheet(isPresented: self.$shouldDisplayLoginView, content: {
        LoginView()
      })
      .onReceive(self.object.$requiresAuthentication) { requiresAuthentication in
        DispatchQueue.main.async {
          self.shouldDisplayLoginView = requiresAuthentication
        }
      }
    }

    internal var body: some View {
      if #available(iOS 15.4, *) {
        #if canImport(GroupActivities) && os(iOS)
          mainView.sheet(
            item: self.$activity
          ) { activity in
            GroupActivitySharingView<FloxBxActivity>(
              activity: activity.getGroupActivity()
            )
          }
          .onReceive(self.object.shareplayObject.$activity, perform: { activity in
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

    internal init() {}
  }

  private struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
  }
#endif
