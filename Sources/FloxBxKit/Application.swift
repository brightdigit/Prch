//
//  FloxBxApp.swift
//  Shared
//
//  Created by Leo Dion on 5/10/21.
//


#if canImport(SwiftUI)
import SwiftUI

public protocol Application: App {
  
}

public extension Application {
  var body: some Scene {
      WindowGroup {
        ContentView().environmentObject(ApplicationObject()).onAppear {
          Sentry.start(.client)
        }
      }
  }
}
#endif
