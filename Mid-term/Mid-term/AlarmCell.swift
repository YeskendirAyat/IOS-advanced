//
//  AlarmCell.swift
//  Mid-term
//
//  Created by  Yeskendir Ayat on 21.10.2021.
//

import Foundation
import SwiftUI
struct AlarmCell: View {
    @ObservedObject var alarmViewModel:AlarmViewModel
    var index: Int
    @Binding var hour:String
    @Binding var min:String
    @Binding var description:String
    @Binding var isAvailable:Bool
    @State var isOn:Bool
    var body: some View{
        HStack{
            VStack{
                if(isAvailable){
                    Text(hour+":"+min).font(.largeTitle).frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    Text(description).frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
                else{
                    Text(hour+":"+min).font(.largeTitle).frame(minWidth: 0, maxWidth: .infinity, alignment: .center).foregroundColor(.gray)
                    Text(description).frame(minWidth: 0, maxWidth: .infinity, alignment: .center).foregroundColor(.gray)
                }
//                Text(hour+":"+min).font(.largeTitle).frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
//                Text(description).frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            Toggle("", isOn: $isOn)
                .onTapGesture {
                    alarmViewModel.setAlarm(at: index, Alarm: Alarm(hour: hour, min: min, description: description, isAvailable: !isAvailable))
                }
        }.padding()
    }
}
