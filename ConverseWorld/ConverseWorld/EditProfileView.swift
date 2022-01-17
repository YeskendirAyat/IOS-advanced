//
//  EditProfileView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 22.12.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
struct EditProfileView: View {
    @EnvironmentObject var vm : MessagesViewModel
    @State private var showSheet = false
    @State private var image = UIImage()
    @State private var showImage = false
    @State private var bio = ""
    @State private var age = ""
    @State private var interest = ""
    @State private var nationality = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var religion = ""
    
    var body: some View {  
        ScrollView{
            VStack{
                if showImage{
                    Image(uiImage: self.image)
                            .resizable()
                            .padding(.all, 4)
                            .background(Color.black.opacity(0.2))
                            .aspectRatio(contentMode: .fill)
                            .padding(8)
                }
//                WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(minWidth: 0, idealWidth: 200, maxWidth: 200, minHeight: 0, idealHeight: 200, maxHeight: 200, alignment: .center)
//                    .cornerRadius(200)
//                    .clipped()
                VStack{
                    Text("Set image")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1736278832, green: 0.1726026833, blue: 0.1744204164, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(2)
                            .foregroundColor(.white)
                            .onTapGesture {
                                showSheet.toggle()
                                showImage = true
                            }
                }.sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
                .padding()
                Divider()
                if vm.chatUser != nil{
                    Group {
                        TextField("\(vm.chatUser!.name)", text: $name)
                        TextField("\(vm.chatUser!.surname)", text: $surname)
                        TextField("\(vm.chatUser!.bio)", text: $bio)
                        TextField("\(vm.chatUser!.age)", text: $age)
                        TextField("\(vm.chatUser!.religion)", text: $religion)
                        TextField("\(vm.chatUser!.nationality)", text: $nationality)
                        TextField("\(vm.chatUser!.interest)", text: $interest)
                    }
                    .font(Font.system(size: 15, weight: .medium, design: .serif))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Button{
                    if !showImage{
                        storeUserInformation(imageProfileUrl: URL(string: vm.chatUser!.profileImageUrl)!)
                    }
                    else{
                        persistImageToStorage()
                    }
                } label: {
                    Text("Save!")
                }
                .buttonStyle(GrowingButton())
            }
        }.padding()
    }
    private func persistImageToStorage() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    print("Failed to push image to Storage: \(err)")
                    return
                }
                ref.downloadURL { url, err in
                    if let err = err {
                        print("Failed to retrieve downloadURL: \(err)")
                        return
                    }
                    guard let url = url else{ return }
                    self.storeUserInformation(imageProfileUrl: url)
                }
            }
        }
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": vm.chatUser!.email, "uid": vm.chatUser!.uid, "profileImageUrl": imageProfileUrl.absoluteString, "name": name, "surname": surname, "nationality": nationality, "age": age,"religion": religion,"interest": interest,"bio": bio, "savedEvents": vm.chatUser!.savedEvents] as [String : Any]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid)
            .setData(userData) { err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success")
            }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
