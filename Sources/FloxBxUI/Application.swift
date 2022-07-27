#if canImport(SwiftUI)
  import SwiftUI
  import FloxBxUI

  public protocol Application: App {}

  public extension Application {
    var body: some Scene {
      WindowGroup {
        ContentView().environmentObject(ApplicationObject())
      }
    }
  }
#endif
