//
//  TabBarView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 13.12.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift
struct TabBarView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    @StateObject private var vm = MessagesViewModel()
    var body: some View {
        TabView{
            NewsView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
            }
            AllUsersView()
                .environmentObject(vm)
                .tabItem {
                    Image(systemName: "person.3")
            }
            ChatView()
                .tabItem {
                    Image(systemName: "message")
            }
            SavedEventsView()
                .tabItem{
                    Image(systemName: "text.badge.star")
                }
            ProfileView()
                .environmentObject(vm)
                .tabItem {
                    Image(systemName: "person")
            }
        }
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            ContentView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
            })
        }
    }
}
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
