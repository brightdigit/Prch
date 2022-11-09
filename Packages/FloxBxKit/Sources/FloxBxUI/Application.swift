#if canImport(SwiftUI)
  import SwiftUI
  public protocol Application: App {}

  extension Application {
    public var body: some Scene {
      WindowGroup {
        ContentView().environmentObject(ApplicationObject())
      }
    }
  }
#endif
