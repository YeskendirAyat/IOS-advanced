//
//  ContentView.swift
//  Welcome Page
//
//  Created by  Yeskendir Ayat on 12.09.2021.
//

import SwiftUI

struct ContentView: View {
    @State var email:String = ""
    @State var password:String = ""
    var body: some View {
        ZStack{
            Background()
            VStack(spacing:10){
                WelcomeText()
                CustomTextField(textField: TextField("Email", text: $email), imageName: "envelope")
                CustomTextField(textField: TextField("Password", text: $email), imageName: "lock")
                Button(action: {}){
                    loginButton()
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Background: View {
    var body: some View {
        Image("bgImage1")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .blur(radius: 3)
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("Welcome to SWIFTUI")
            .font(.system(size: 37))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct CustomTextField: View {
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.gray)
            textField
            }
            .frame(height: 28)
            .padding()
            .foregroundColor(.gray)
            .background(Color.white)
            .cornerRadius(10)
        }
}

struct loginButton: View {
    var body: some View {
        Text("Login")
            .padding()
            .foregroundColor(.white)
            .font(.title)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color(red: 255, green: 50, blue: 50,opacity:0.0035)).cornerRadius(10)
    }
}
