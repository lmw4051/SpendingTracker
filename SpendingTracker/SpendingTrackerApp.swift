//
//  SpendingTrackerApp.swift
//  SpendingTracker
//
//  Created by David Lee on 12/29/22.
//

import SwiftUI

@main
struct SpendingTrackerApp: App {
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      MainView()
//      ContentView()
//        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
