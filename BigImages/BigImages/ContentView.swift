//
//  ContentView.swift
//  BigImages
//
//  Created by  Yeskendir Ayat on 15.10.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var photoViewModel = PhotoViewModel()
    var body: some View{
        NavigationView{
            List{
                ForEach(photoViewModel.images){image in
                    NavigationLink(destination: ImageDetailView(photo: image)){
                        Text(image.name)
                    }
                }
            }.navigationBarTitle(Text("Images"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ImageDetailView: View {
    @ObservedObject var photo:Photo
    @State var count:Int = 0
    var body: some View{
        VStack(spacing: 20){
            LoadImageView(photo: self.photo)
            LoadImageView(photo: self.photo)
            LoadImageView(photo: self.photo)
        }.padding()
    }
}
struct LoadImageView: View{
    @ObservedObject var image: LoadImage
    init(photo:Photo){
        self.image = LoadImage(urlString:photo.url)
    }
    var body: some View{
        Image(uiImage: UIImage(data: self.image.imageData) ?? UIImage()).resizable()
    }
}
class LoadImage: ObservableObject{
    @Published var imageData = Data()
    init(urlString: String){
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url){ data, response, error in
            guard let data = data else { return }
            DispatchQueue.global(qos: .utility).async {
                self.imageData = data
            }
        }.resume()
    }
}

