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
    @State var showEdit = false
    @EnvironmentObject var vm : MessagesViewModel
    var body: some View{
        NavigationView{
            ScrollView{
                NavigationLink("", isActive: $showEdit) {
                    EditProfileView(vm: _vm)
                }
                VStack{
                    WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, idealWidth: 200, maxWidth: 200, minHeight: 0, idealHeight: 200, maxHeight: 200, alignment: .center)
                        .cornerRadius(200)
                        .clipped()
                    VStack{
                        Text(vm.chatUser?.name.replacingOccurrences(of: "@gmail.com", with: "") ?? "email")
                            .font(.largeTitle)
                            .fontWeight(.light)
                        Text(vm.chatUser?.surname ?? "")
                            .font(.title2)
                            .fontWeight(.light)
                    }
                    Divider()
                    VStack{
                        Text("Edit profile")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1736278832, green: 0.1726026833, blue: 0.1744204164, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                                .cornerRadius(2)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    showEdit.toggle()
                                }
                    }.padding()
                    VStack{
                        if vm.chatUser != nil{
                            Divider()
                            Text("bio: ").foregroundColor(.gray) + Text(vm.chatUser!.bio)
                            Divider()
                            Text("age: ").foregroundColor(.gray) + Text(vm.chatUser!.age)
                            Divider()
                            Text("religion: ").foregroundColor(.gray) + Text(vm.chatUser!.religion)
                            Divider()
                            Text("nationality: ").foregroundColor(.gray) + Text(vm.chatUser!.nationality)
                            Divider()
                            Text("interest").foregroundColor(.gray) + Text(vm.chatUser!.interest)
                        }
                    }
                    .padding()
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
                .toolbar {
                    Button {
                        shouldShowLogOutOptions.toggle()
                    } label: {
                        Text("Sign out")
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .regular))
                            .rotationEffect(.degrees(90))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
