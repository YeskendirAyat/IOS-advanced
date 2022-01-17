//
//  UserInfoView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 16.12.2021.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
struct UserInfoView: View {
    var chatUser: ChatUser?
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
    }
    var body: some View {
        ScrollView{
            VStack{
                WebImage(url: URL(string: chatUser?.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, idealWidth: 200, maxWidth: 200, minHeight: 0, idealHeight: 200, maxHeight: 200, alignment: .center)
                    .cornerRadius(200)
                    .clipped()
                VStack{
                    Text(chatUser?.name.replacingOccurrences(of: "@gmail.com", with: "") ?? "email")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    Text(chatUser?.surname ?? "")
                        .font(.title2)
                        .fontWeight(.light)
                }
                Divider()
                VStack{
                    if chatUser != nil{
                        Divider()
                        Text("bio: ").foregroundColor(.gray) + Text(chatUser!.bio)
                        Divider()
                        Text("age: ").foregroundColor(.gray) + Text(chatUser!.age)
                        Divider()
                        Text("religion: ").foregroundColor(.gray) + Text(chatUser!.religion)
                        Divider()
                        Text("nationality: ").foregroundColor(.gray) + Text(chatUser!.nationality)
                        Divider()
                        Text("interest").foregroundColor(.gray) + Text(chatUser!.interest)
                    }
                }
                .padding()
            }
        }
    }
//        WebImage(url: URL(string: self.chatUser!.profileImageUrl ))
//            .resizable()
//            .frame(width: 30, height: 30)
//            .clipped()
//            .cornerRadius(30)
//            .overlay(RoundedRectangle(cornerRadius: 30)
//                        .stroke(Color.blue, lineWidth: 1))
//            .shadow(radius: 2)
//        Text(chatUser?.email ?? "email")
//        Text(chatUser?.interest ?? "interest")
//        Text(chatUser?.nationality ?? "nationality")
////        Text(chatUser? ?? "email")
        
}
//}
