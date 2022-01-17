//
//  AddEventView.swift
//  ConverseWorld
//
//  Created by  Yeskendir Ayat on 19.12.2021.
//

import SwiftUI
import Firebase
struct AddEventView: View {
    @State var title = ""
    @State var text = ""
    @State var coment = ""
    @State var location = ""
    @State private var date = Date()
    @State private var image = UIImage()
    @State private var showSheet = false
    @State private var showImage = false
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
                Text("Choose photo")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1736278832, green: 0.1726026833, blue: 0.1744204164, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                        .cornerRadius(1)
                        .foregroundColor(.white)
                        .onTapGesture {
                            showImage.toggle()
                            showSheet = true
                        }
            }.sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                }
            eventPreView.cornerRadius(10).frame(maxWidth: .infinity)
            VStack(spacing: 0){
                VStack {
                    DatePicker(selection: $date, in: Date()..., displayedComponents: [.date, .hourAndMinute]) {
                        Text("Select passing date:").font(.custom("Helvetica Neue", size: 18))
                    }
                }
                .padding()
                    .frame(maxHeight: .infinity)
                eventEditView
            }.frame(maxWidth: .infinity)
            .padding()
            Spacer()
            .navigationBarTitle("Preview")
            .navigationBarTitleDisplayMode(.large)
        }
        .padding()
    }
    private var eventPreView: some View {
        VStack{
            VStack(spacing:10){
                Text("Title: \(title)").font(.custom("Helvetica Neue", size: 20)).bold()
                Text("Title: \(text)").font(.custom("Helvetica Neue", size: 18))
                Text("Coment: \(coment)").font(.custom("Helvetica Neue", size: 18))
                Text("location: \(location)").font(.custom("Helvetica Neue", size: 18))
                Text("Date is \(date.formatted(date: .long, time: .omitted))").font(.custom("Helvetica Neue", size: 18))
                Text("Time \(date.formatted(date: .omitted, time: .shortened))").font(.custom("Helvetica Neue", size: 18))
            }
            .frame(alignment: .leading)
            .padding()
            .cornerRadius(20)
            .background(.quaternary)
        }
    }
    private var eventEditView: some View {
        VStack{
            VStack(spacing: 0){
                TextField("Title...", text: $title).padding().background(.secondary)
                Divider()
                 .frame(height: 1)
                 .padding(.horizontal, 30)
                 .background(.background)
                TextField("Text...", text: $text).padding().background(.secondary)
                Divider()
                 .frame(height: 1)
                 .padding(.horizontal, 30)
                 .background(.background)
                TextField("Location...", text: $location).padding().background(.secondary)
                Divider()
                 .frame(height: 1)
                 .padding(.horizontal, 30)
                 .background(.background)
                TextField("Coment...", text: $coment).padding().background(.secondary)
            }.cornerRadius(20)
            Button {
                persistImageToStorage()
            } label: {
                Text("ADD")
            }
            .buttonStyle(GrowingButton())
        }.opacity(0.75)
    }
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let document = FirebaseManager.shared.firestore.collection("events").document()
        let ref = FirebaseManager.shared.storage.reference(withPath: document.documentID)
        guard let imageData = self.image.jpegData(compressionQuality: 0.5) else { return }
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
                    let eventData = [
                        "authorId": uid,
                        "title": self.title,
                        "text": self.text,
                        "location": self.location,
                        "postDate": Date(),
                        "eventImageUrl" : url.absoluteString,
                        "coment" : self.coment,
                        "passingDate": self.date]  as [String : Any]
                    document.setData(eventData) { error in
                        if let error = error {
                            print("Failed to save message into Firestore: \(error)")
                            return
                        }
                    }
                }
            }
        }
}
struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
            .previewInterfaceOrientation(.portrait)
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
