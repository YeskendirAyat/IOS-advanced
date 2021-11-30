//
//  ContentView.swift
//  ContactBook
//
//  Created by  Yeskendir Ayat on 17.09.2021.
//

import SwiftUI
import Foundation
// View Models
class Contact: Identifiable, ObservableObject{
    var id = UUID()
    var name:String
    var lastName:String
    var phoneNumber:String
    var gender:String
    init(name: String, lastName:String, phoneNumber:String, gender:String) {
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.gender = gender
    }
}
class ContactViewModel: ObservableObject{
    
    @Published var contacts:[Contact] = [
        .init(name: "Travis", lastName: "Scott", phoneNumber: "1234567890",gender: "male"),
        .init(name: "Savage", lastName: "21", phoneNumber: "2121212121",gender: "female"),
        .init(name: "Post", lastName: "Malone", phoneNumber: "643728473",gender: "male"),
        .init(name: "Drake", lastName: "Graham", phoneNumber: "4857339244",gender: "female")
    ]
    func removeContact(at indexSet: IndexSet) {
        contacts.remove(atOffsets: indexSet)
    }
//    func removeContactbyID(contact: UUID) {
//        contacts.removeAll(where:{$0.id == contact})
//    }
//    func addContact(element:Contact){
//        contacts.append(element)
//    }
}
// Table View
extension RandomAccessCollection {
    func indexed() -> Array<(offset: Int, element: Element)> {
        Array(enumerated())
    }
}
struct ContentView: View{
    @StateObject var contactViewModel = ContactViewModel()
    var body: some View{
        NavigationView{
            List{
                ForEach(contactViewModel.contacts.indexed(), id: \.1.id){ index,contact in
                    NavigationLink(destination: ContactDetailView(contact: self.$contactViewModel.contacts[index], contacts: self.contactViewModel, index: index)){
                        ContactView(contact: self.contactViewModel.contacts[index])
                    }
                }.onDelete(perform:contactViewModel.removeContact)
            }
            .navigationBarItems(trailing:
            HStack{
                NavigationLink(destination: AddContactView(contacts: self.contactViewModel, selectedGender: "male")){
                    Image(systemName: "plus").font(.title).foregroundColor(.blue)
                }.buttonStyle(PlainButtonStyle())
            }).navigationBarTitle(Text("Contacts"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//
struct ContactView: View {
    @ObservedObject var contact: Contact
    var body: some View{
        HStack{
            Image(contact.gender)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
            VStack(alignment: .center, spacing:10){
                Text(contact.lastName + "  " + contact.name).font(.title3).bold()
                Text(contact.phoneNumber).foregroundColor(.gray)
            }.frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}
struct AddContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var contacts:ContactViewModel
    @State  var newContactName: String = ""
    @State  var newContactLastName: String = ""
    @State  var newContactPhoneNumber: String = ""
    var genders = ["male", "female"]
    @State var selectedGender:String = ""
    var body: some View{
        VStack(spacing: 10){
            Image(selectedGender)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            CustomTextField(textField: TextField("Name", text: $newContactName), imageName: "person")
            CustomTextField(textField: TextField("LastName", text: $newContactLastName), imageName: "person.fill")
            CustomTextField(textField: TextField("Phone", text: $newContactPhoneNumber), imageName: "phone")
            Picker("Please choose a color", selection: $selectedGender) {
                    ForEach(genders, id: \.self) {
                            Text($0)
                    }
                }
            Button(action: {
                contacts.contacts.append(.init(name: newContactName, lastName: newContactLastName, phoneNumber: newContactPhoneNumber,gender: selectedGender))
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                CustomButtonLabel(txt: "Save", color: Color(red: 28/255, green: 52/255, blue: 97/255))
            })
            Spacer()
        }
        .padding()
    }
}
//
struct ContactDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var contact:Contact
    @ObservedObject var contacts:ContactViewModel
    var index:Int
    var body: some View{
        VStack(spacing: 10){
            Image(contact.gender)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            CustomText(txt: contact.lastName)
            CustomText(txt: contact.name)
            CustomText(txt: contact.phoneNumber)
            Spacer()
            Button(action: {
                if index == contacts.contacts.count{
                    contacts.contacts.removeLast()
                }
                else{
                    contacts.contacts.remove(at: index)
                }
                self.presentationMode.wrappedValue.dismiss()
            }, label: { CustomButtonLabel(txt: "Delete", color: Color(red: 235/255, green: 77/255, blue: 61/255))}).padding(.horizontal)
            NavigationLink(destination: EditContactView(newContactName: contact.name, newContactLastName: contact.lastName, newContactPhoneNumber: contact.phoneNumber, contact: $contact, selectedGender: contact.gender)){
                CustomButtonLabel(txt: "Change", color: Color(red: 28/255, green: 52/255, blue: 97/255))
            }
                .padding()
                .buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}

struct EditContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @State  var newContactName: String = ""
    @State  var newContactLastName: String = ""
    @State  var newContactPhoneNumber: String = ""
    @Binding var contact:Contact
    var genders = ["male", "female"]
    @State var selectedGender:String = ""
    var body: some View{
        VStack(spacing: 10){
            Image(contact.gender)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
            CustomTextField(textField: TextField("Name", text: $newContactName), imageName: "person")
            CustomTextField(textField: TextField("Name", text: $newContactLastName), imageName: "person.fill")
            CustomTextField(textField: TextField("Phone", text: $newContactPhoneNumber), imageName: "phone")
            VStack {
                Subview(operatorValueString: $contact.gender)
                }
            Button(action: {
                contact = Contact(name: newContactName, lastName: newContactLastName, phoneNumber: newContactPhoneNumber, gender: contact.gender)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                CustomButtonLabel(txt: "Save", color: Color(red: 28/255, green: 52/255, blue: 97/255))
            })
            Spacer()
        }
        .padding()
    }
}
//
struct Subview: View {
    @Binding var operatorValueString: String
    @State private var queryType: Int = 0
    var genders = ["male", "female"]
    @State var selectedGender:String = ""
    var body: some View {

        let binding = Binding<Int>(
            get: { self.queryType },
            set: {
                self.queryType = $0
                self.operatorValueString = self.genders[self.queryType]
            })

        return Picker(selection: binding, label: Text("Query Type")) {
            ForEach(genders.indices) { index in
                Text(self.genders[index]).tag(index)
            }
        }
    }
}
//
struct CustomTextField: View {
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
                Image(systemName: imageName)
                    .foregroundColor(.black)
                textField
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color(red: 220/255, green: 220/255, blue: 220/255))
        .shadow(color: .black, radius: 10, x: 0.0, y: 0.0)
            .cornerRadius(10)
        }
}


struct CustomText: View {
    var txt:String
    var body: some View {
        Text(txt).font(.title2)
            .bold()
            .padding([.leading,.trailing], 20)
            .padding([.bottom,.top],5)
            .background(Color(red: 220/255, green: 220/255, blue: 220/255))
            .cornerRadius(5.0)
    }
}

struct CustomButtonLabel: View {
    var txt:String
    var color:Color
    var body: some View {
        Text(txt)
            .foregroundColor(.white)
            .font(.title2)
            .frame(height: 50)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(color)
            .cornerRadius(10)
    }
}
