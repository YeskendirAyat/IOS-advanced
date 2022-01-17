//
//  SavedEventsView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 18.12.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
class SavedEventsViewModel: ObservableObject {
    @Published var events = [Event]()
    private var firestoreListener: ListenerRegistration?
    private var firestoreListener2: ListenerRegistration?
    @Published var chatUser: ChatUser?
    init() {
        fetchCurrentUser()
        fetchSavedEvents()
    }
    func fetchCurrentUser() {
        firestoreListener2?.remove()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener2 = FirebaseManager.shared.firestore
            .collection("users").addSnapshotListener({ querySnapshot, error in
                if let error = error {
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
    func fetchSavedEvents() {
        firestoreListener?.remove()
        self.events.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("events")
            .order(by: "postDate", descending: true)
            .addSnapshotListener({ querySnapshot, error in
                if let error = error {
                    print("Failed to fetch users: \(error)")
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    if let index = self.events.firstIndex(where: { rm in
                        return rm.documentId == docId
                    }) {
                        self.events.remove(at: index)
                    }
                    if self.chatUser == nil{ return }
                    if self.chatUser!.savedEvents.contains(docId){
                        self.events.insert(.init(documentId: docId, data: change.document.data()), at: 0)
                    }
                })
            })
    }
}
struct SavedEventsView: View {
    @StateObject var vm = SavedEventsViewModel()
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(vm.events) { event in
                    VStack(spacing: 5) {
                        Text("posted: " + event.getTimeOfpostDate)
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size:12, design: .default))
                        WebImage(url: URL(string: event.eventImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: .infinity, alignment: .center)
                            .clipped()
                            .cornerRadius(5)
                        Text(event.title)
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size:30, design: .rounded))
                        Text(event.text)
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size:20, design: .default))
                        Text(event.coment)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size:18, design: .default))
                            .foregroundColor(.gray)
                        Text(event.location + " " + event.getTimeOfpassingDate)
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size:12, design: .default))
                        Spacer()
                    }.padding(.horizontal)
                    Button{
                        saveEvent(id: event.documentId)
                    }label: {
                        Text("Unsave").padding(5)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1736278832, green: 0.1726026833, blue: 0.1744204164, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                    .cornerRadius(2)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                }
                .navigationBarTitle("Saved Events")
            }
        }
    }
    func saveEvent(id:String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        if vm.chatUser!.savedEvents.contains(id) {
            FirebaseManager.shared.firestore.collection("users")
                .document(uid)
                .updateData([
                    "savedEvents": FieldValue.arrayRemove([id])
                ])
        }
//        vm.fetchSavedEvents()
//        else{
//            FirebaseManager.shared.firestore.collection("users")
//            .document(uid)
//            .updateData([
//                "savedEvents": FieldValue.arrayUnion([id])
//            ])
//        }
    }
}

//struct SavedEventsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedEventsView()
//    }
//}
