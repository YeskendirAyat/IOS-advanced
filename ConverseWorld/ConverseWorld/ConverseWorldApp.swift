//
//  ConverseWorldApp.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 12.12.2021.
//

import SwiftUI
import Firebase
@main
struct ConverseWorldApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
//            let userViewModel = UserViewModel()
            TabBarView()
//                .environmentObject(userViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
////        FirebaseApp.configure()
//        return true
//    }
//}
