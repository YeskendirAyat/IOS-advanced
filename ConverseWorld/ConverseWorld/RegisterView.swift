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
    @State private var bio = ""
    @State private var age = ""
    @State private var interest = ""
    @State private var nationality = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var religion = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    Section{
                        TextField("Name", text: $name)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Surname", text: $surname)
                            .keyboardType(.emailAddress)
                        TextField("Bio", text: $bio)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Age", text: $age)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Interest", text: $interest)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        TextField("Nationality", text: $nationality)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .autocapitalization(.none)
                        TextField("Religion", text: $religion)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
                                    
                            }
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1736278832, green: 0.1726026833, blue: 0.1744204164, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(2)
                        .foregroundColor(.white)
                    }
                }
            }
            .navigationTitle("Registration")
        }
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
                    guard let url = url else{ return }
                    self.storeUserInformation(imageProfileUrl: url)
                }
            }
        }
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString, "name": name, "surname": surname, "nationality": nationality, "age": age,"religion": religion,"interest": interest,"bio": bio, "savedEvents": []] as [String : Any]
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
