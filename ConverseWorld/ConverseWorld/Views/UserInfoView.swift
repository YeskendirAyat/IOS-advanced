//
//  UserInfoView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 16.12.2021.
//

import SwiftUI

struct UserInfoView: View {
    var chatUser: ChatUser?
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
    }
    var body: some View {
        Text(chatUser?.email ?? "email")
    }
}
//
//struct UserInfoView_Previews: PreviewProvider {
//    static var previews: some View {
////        UserInfoView()
//        ChatView()
//    }
//}
