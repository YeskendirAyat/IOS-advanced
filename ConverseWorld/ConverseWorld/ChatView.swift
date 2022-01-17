//
//  ChatView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 13.12.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift
struct ChatView: View {
    @State var shouldNavigateToChatLogView = false
    @State var chatUser: ChatUser?
    @StateObject private var vm = MessagesViewModel()
    var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    var body: some View {
        NavigationView {
            VStack {
                messagesView
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .navigationTitle("Chat")
        }
    }
    private var messagesView: some View {
        ScrollView {
            ForEach(vm.recentMessages) { recentMessage in
                VStack {
                    Button {
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                        let data = ["id":uid,"uid":uid,"email": recentMessage.email, "profileImageUrl": recentMessage.profileImageUrl]
                        self.chatUser = .init(documentId: uid, data: data)
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                    } label: {
                        HStack(spacing: 16) {
//                            vm.getUsersImage(uid: recentMessage.fromId)
                            WebImage(url: URL(string: recentMessage.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipped()
                                .cornerRadius(64)
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 1))
                                .shadow(radius: 5)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(recentMessage.email)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                if String(recentMessage.text).count < 50{
                                    Text(recentMessage.text)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.leading)
                                }
                                else{
                                    Text(String(recentMessage.text.prefix(50)))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            Spacer()
                            Text(recentMessage.getTime)
                        }
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.bottom, 50)
        }
    }
}


class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    func handleSend() {
        if chatText.isEmpty{
            return
        }
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId": fromId,
                           "toId": toId,
                           "text": self.chatText,
                           "timestamp": Date()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
//            print("Successfully saved current user sending message")
            self.persistRecentMessage()
            self.chatText = ""
            self.count += 1
        }
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": chatUser.profileImageUrl,
            "email": chatUser.email
        ] as [String : Any]
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromId": uid,
            "toId": toId,
            "profileImageUrl": currentUser.profileImageUrl,
            "email": currentUser.email
        ] as [String : Any]
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    @Published var count = 0
}

struct ChatLogView: View {
    let chatUser: ChatUser?
    @ObservedObject var vm: ChatLogViewModel
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    var body: some View {
        ZStack {
            messagesView
            NavigationLink("", isActive: $showUserInfo) {
                UserInfoView(chatUser: self.chatUser)
            }
        }
        .navigationTitle(chatUser?.email ?? "")
        .toolbar {
            transitionToUserInfo
        }
        .navigationBarTitleDisplayMode(.inline)
            
    }
    @State var showUserInfo = false
    private var transitionToUserInfo: some View {
        Button {
            showUserInfo.toggle()
        } label: {
            HStack {
                WebImage(url: URL(string: self.chatUser!.profileImageUrl ))
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipped()
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.blue, lineWidth: 1))
                    .shadow(radius: 2)
            }
        }
    }
    static let emptyScrollToString = "Empty"
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
//                .background(Color(.init(white: 0.95, alpha: 1)))
                .background(.background)
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            } else {
                Text("something wrong ios 15 in not available!")
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            ZStack {
                TextField("Enter message...", text: $vm.chatText)
                    .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1.5)
                        )
            }
            .frame(height: 20)
            .padding(.vertical)
            Button {
                vm.handleSend()
            } label: {
                Image(systemName: "paperplane.fill").imageScale(.large)
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    VStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(20)
                }
            } else {
                HStack {
                    VStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(20)
                    Spacer()
                }
            }
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid{
                    Text(message.getTime)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(Font.system(size:15, design: .default))
            }
            else{
                Text(message.getTime)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size:15, design: .default))
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
