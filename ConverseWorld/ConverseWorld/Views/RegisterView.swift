//
//  RegisterView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 12.12.2021.
//

import SwiftUI

struct RegisterView: View {
    @State var email = ""
    @State var password = ""
    @State var name = ""
    @State var surname = ""
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        VStack(spacing: 15) {
            Image("converseWorld")
                .resizable()
                .frame(width: 200, height: 200)
                .padding()
            VStack(spacing: 30){
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
            }   .padding(12)
                .background(.secondary)
                .cornerRadius(10)
            Button {
                FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
                    result, err in
                        if let err = err {
                            print("Failed to create user:", err)
                            return
                        }
                    self.persistImageToStorage()
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack(alignment: .center){
                    Text("Create")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 100)
                        .font(.system(size: 20, weight: .semibold))
                }.background(Color.green).cornerRadius(10)
            }
        }.navigationBarTitle("", displayMode: .inline)
        .padding()
    }
    private func persistImageToStorage() {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = UIImage(named: "converseWorld")!.jpegData(compressionQuality: 0.5) else { return }
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
//                    self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
//                    print(url?.absoluteString)
                    guard let url = url else{ return }
                    self.storeUserInformation(imageProfileUrl: url)
                }
            }
        }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString, "name": self.email, "surname": "N/A", "nationality": "qazaq", "age":"19","religion":"","interest":"","bio":"BIO"]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    return
                }

                print("Success")
            }
    }
}
