//
//  PocketML_iOSApp.swift
//  PocketML-iOS
//
//  Created by Steven Yu on 5/4/24.
//

import SwiftUI
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PocketML_iOSApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .onAppear {
                  Task {
                      await APIService.shared.getJobs()
                      await APIService.shared.getSpecificJob(id: 1)
                  }
              }
      }
    }
  }
}
