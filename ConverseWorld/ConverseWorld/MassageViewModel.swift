//
//  UserViewModel.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 12.12.2021.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class MessagesViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var users = [ChatUser]()
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        fetchRecentMessages()
    }
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    private var firestoreListener2: ListenerRegistration?
    func fetchRecentMessages() {
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    self.recentMessages.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                })
            }
    }
    func fetchCurrentUser() {
        firestoreListener2?.remove()
        self.users.removeAll()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener2 = FirebaseManager.shared.firestore
            .collection("users").addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if docId == uid {
                        self.chatUser = .init( documentId: docId, data: change.document.data())
                        FirebaseManager.shared.currentUser = .init( documentId: docId,data: change.document.data())
                    }
                })
            })
    }
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}
