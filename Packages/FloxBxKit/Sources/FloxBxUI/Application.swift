#if canImport(SwiftUI)
  import SwiftUI
  public protocol Application: App {}

  public extension Application {
    var body: some Scene {
      WindowGroup {
        ContentView().environmentObject(ApplicationObject())
      }
    }
  }
#endif
