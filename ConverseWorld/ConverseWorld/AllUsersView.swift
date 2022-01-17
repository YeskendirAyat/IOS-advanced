//
//  CreateNewMessageView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Brian Voong on 11/16/21.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
class AllUsersViewModel: ObservableObject {
    @Published var users = [ChatUser]()
    private var firestoreListener: ListenerRegistration?
    init() {
        fetchAllUsers()
    }
    func fetchAllUsers() {
        firestoreListener?.remove()
        self.users.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("users")
            .order(by: "email", descending: true)
            .addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.users.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.users.remove(at: index)
                    }
                    if docId != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                    }
                })
            })
    }
}
struct AllUsersView: View {
    var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    @ObservedObject var vm = AllUsersViewModel()
    @State var shouldNavigateToChatLogView = false
    @State var chatUser: ChatUser?
    var body: some View {
        NavigationView {
            VStack{
                userView
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
        }
    }
    var userView: some View {
        ScrollView {
            ForEach(vm.users) { user in
                Button {
                    self.chatUser = user
                    self.chatLogViewModel.chatUser = self.chatUser
                    self.chatLogViewModel.fetchMessages()
                    self.shouldNavigateToChatLogView.toggle()
                } label: {
                    HStack(spacing: 16) {
                        WebImage(url: URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label), lineWidth: 2)
                            )
                        VStack{
                            Text(user.name + " " + user.surname)
                                .font(.title2)
                            Text(user.bio)
                                .foregroundColor(.gray)
                                .fontWeight(.light)
                            Text(user.interest)
                                
                        }
                    }.padding(.horizontal)
                }
                Divider()
                    .padding(.vertical, 8)
            }
        }.navigationTitle("Users")
    }
}
