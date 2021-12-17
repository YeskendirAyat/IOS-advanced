//
//  ContentView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 12.12.2021.
//

import SwiftUI
import CoreData
import Firebase



struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//    init(){
//        FirebaseApp.configure()
//    }
//    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showingDetail = false
//    let userViewModel = UserViewModel()
    let didCompleteLoginProcess: () -> ()
    @State var email = ""
    @State var password = ""
    var body: some View {
        NavigationView {
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
                    FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
                        if let err = err {
                            print("Failed to login user:", err)
                            return
                        }
                        print("Successfully logged in as user: \(result?.user.uid ?? "")")
                        self.didCompleteLoginProcess()
//                    FirebaseManager.shared.auth.signIn(withEmail: email, password: password){ result, err in
//                        if let err = err {
//                            print("Failed to login user:", err)
//                            return
//                        }
//                        self.didCompleteLoginProcess()
                    }
                } label: {
                    HStack(alignment: .center){
                        Text("Log In")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 100)
                            .font(.system(size: 20, weight: .semibold))
                    }.background(Color.green).cornerRadius(10)
                }
                Spacer()
                Button("Register") {
                            showingDetail = true
                    }.sheet(isPresented: $showingDetail) {
                        RegisterView()
                    }
            }.navigationBarTitle("", displayMode: .inline)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(didCompleteLoginProcess: {
            
        })
//            .environmentObject(UserViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
