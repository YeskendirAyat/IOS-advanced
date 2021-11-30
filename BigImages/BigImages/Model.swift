//
//  Model.swift
//  BigImages
//
//  Created by  Yeskendir Ayat on 15.10.2021.
//

import UIKit
class Photo: Identifiable,ObservableObject{
    var id = UUID()
    var name:String
    var url:String
    init(name: String, url:String) {
        self.name = name
        self.url = url
    }
}
class PhotoViewModel: ObservableObject{
    @Published var images:[Photo] = [
        Photo(name: "first", url: "https://wallpaperaccess.com/full/533108.jpg"),
        Photo(name: "second", url: "https://wallpaperaccess.com/full/2416007.jpg"),
        Photo(name: "third", url: "https://cdn.wallpapersafari.com/73/0/MsxNEw.jpg")
        ]
}
