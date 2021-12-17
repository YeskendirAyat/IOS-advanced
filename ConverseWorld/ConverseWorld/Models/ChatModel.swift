//
//  ChatUser.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 13.12.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseFirestoreSwift



struct ChatUser: Codable, Identifiable {
    
    var id: String { uid }
    let uid, email, profileImageUrl: String
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
struct RecentMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Timestamp
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}


//struct ChatUser: Codable, Identifiable {
//    @DocumentID var id: String?
//    let uid, email, profileImageUrl: String
//}

//struct ChatMessage: Codable, Identifiable {
//    @DocumentID var id: String?
//    let fromId, toId, text: String
//    let timestamp: Date
//}

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: ChatUser?
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let email = "email"
    static let uid = "uid"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let users = "users"
    static let recentMessages = "recent_messages"
}
