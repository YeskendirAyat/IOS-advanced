//
//  Utilities.swift
//  Mid-term
//
//  Created by  Yeskendir Ayat on 22.10.2021.
//

import Foundation
import SwiftUI


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

struct PickerView: View {
    var geometry:GeometryProxy
    @Binding var hourSelection:String
    @Binding var minuteSelection:String
    var times:TimeList = TimeList()
    var body: some View {
        VStack{
            HStack{
                Picker(selection: self.$hourSelection, label: Text("")) {
                    ForEach(times.hoursList, id: \.self, content: { index in
                        Text(index)
                            .tag(index)
                            .font(.largeTitle)
                    }
                )}
                    .frame(width: geometry.size.width/2, height: 150, alignment: .center)
                    .clipped()
                Picker(selection: self.$minuteSelection, label: Text("")) {
                    ForEach(times.minList, id: \.self, content: { index in
                        Text(index)
                                .tag(index)
                                .cornerRadius(10.0)

                                .font(.largeTitle)
                    }
                )}
                    .labelsHidden()
                    .frame(width: geometry.size.width/2, height: 150, alignment: .center)
                    .clipped()
            }
        }
        .padding()
    }
}
struct CustomTextField: View {
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
                Image(systemName: imageName)
                    .foregroundColor(.black)
                textField
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
            .padding()
            .background(Color(red: 220/255, green: 220/255, blue: 220/255))
            .cornerRadius(10)

        }
}
extension RandomAccessCollection {
    func indexed() -> Array<(offset: Int, element: Element)> {
        Array(enumerated())
    }
}
