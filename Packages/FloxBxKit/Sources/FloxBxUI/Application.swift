#if canImport(SwiftUI)
  import FloxBxModels
  import os
  import SwiftUI

  public protocol Application: App {
    var appDelegate: AppDelegate { get }
  }

  extension Application {
    public var body: some Scene {
      WindowGroup {
        ContentView()
      }
    }
  }
#endif
