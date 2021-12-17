//
//  ProfileView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 13.12.2021.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct ProfileView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToChatLogView = false
//     private var vm = UserViewModel
    @EnvironmentObject var vm : UserViewModel
    var body: some View{
        VStack{
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            Text(vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? "email")
                .background(.blue)
                .font(.system(size: 24, weight: .bold))
//            Text( vm.chatUser?.religion ?? "religion")
//                .background(.blue)
//                .font(.system(size: 24, weight: .bold))
//            Text( vm.chatUser?.bio ?? "bio")
//                .background(.blue)
//                .font(.system(size: 24, weight: .bold))
//            Text( vm.chatUser?.nationality ?? "nationality")
//                .background(.blue)
//                .font(.system(size: 24, weight: .bold))
            Button (action:{
                vm.fetchCurrentUser()
            }, label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            })
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
                print("welcome Back")
            })
        }
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
