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

//self.chatUser = ChatUser(data: snapshot!.data()!)
class UserViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
    }
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
                
            }
            self.chatUser = .init(data: data)
            FirebaseManager.shared.currentUser = self.chatUser
        }
    }
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}

struct TabBarView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
    @ObservedObject private var vm = UserViewModel()
    var body: some View {
        TabView{
            NewsView()
                .tabItem {
                    Image(systemName: "book")
            }
            ChatView()
                .tabItem {
                    Image(systemName: "message")
            }
            CreateNewMessageView()
                .tabItem {
                    Image(systemName: "person.2")
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
//        TabBarView()
    }
}
