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
struct ChatUser: Identifiable {
    var id: String { uid }
    let documentId: String
    let uid, email, profileImageUrl, nationality, interest, religion, age, gender, bio,surname, name: String
    var savedEvents: [String]
    init(documentId: String,data: [String: Any]) {
        self.documentId = documentId
        self.uid = data["uid"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.surname = data["surname"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.nationality = data["nationality"] as? String ?? ""
        self.interest = data["interest"] as? String ?? ""
        self.religion = data["religion"] as? String ?? ""
        self.age = data["age"] as? String ?? ""
        self.gender = data["gender"] as? String ?? ""
        self.bio = data["bio"] as? String ?? ""
        self.savedEvents = data["savedEvents"] as? [String] ?? [""]
    }
}
struct RecentMessage: Identifiable {
    var id: String { documentId }
    let documentId: String
    let text, email,fromId, toId,profileImageUrl: String
    let timestamp: Timestamp
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.text = data["text"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
    var getTime:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let date = NSDate(timeIntervalSince1970: TimeInterval(self.timestamp.seconds))
        return dateFormatter.string(from: date as Date)
    }
}
struct Event: Identifiable {
    var id: String { documentId }
    let documentId: String
    let authorId, title, text, coment, eventImageUrl, location: String
    let postDate, passingDate: Timestamp
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.authorId = data["authorId"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.location = data["location"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.postDate = data["postDate"] as? Timestamp ?? Timestamp()
        self.passingDate = data["passingDate"] as? Timestamp ?? Timestamp()
        self.coment = data["coment"] as? String ?? ""
        self.eventImageUrl = data["eventImageUrl"] as? String ?? ""
    }
    var getTimeOfpassingDate:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        let date = NSDate(timeIntervalSince1970: TimeInterval(self.passingDate.seconds))
        return dateFormatter.string(from: date as Date)
    }
    var getTimeOfpostDate:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        let date = NSDate(timeIntervalSince1970: TimeInterval(self.postDate.seconds))
        return dateFormatter.string(from: date as Date)
    }
}
struct ChatMessage: Identifiable {
    var id: String { documentId }
    let documentId: String
    let fromId, toId, text: String
    let timestamp: Timestamp
    init(documentId: String, data: [String: Any]) {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
    var getTime:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MM/dd"
        let date = NSDate(timeIntervalSince1970: TimeInterval(self.timestamp.seconds))
        return dateFormatter.string(from: date as Date)
    }
}
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
