//
//  EditAlarmView.swift
//  Mid-term
//
//  Created by  Yeskendir Ayat on 22.10.2021.
//

import Foundation
import SwiftUI
struct EditAlarmView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var alarmViewModel:AlarmViewModel
    @State var description:String
    @State var hourSelection = "00"
    @State var minuteSelection = "00"
    var index: Int
    var isAvailable: Bool
    var body: some View {
        GeometryReader { geometry in
            if #available(iOS 15.0, *) {
                NavigationView{
                    VStack{
                        VStack(spacing:5){
                            PickerView(geometry: geometry,hourSelection: $hourSelection, minuteSelection: $minuteSelection)
                                .pickerStyle(.wheel)
                            CustomTextField(textField: TextField("Description", text: $description), imageName: "clock")
                        }
                        Spacer()
                        Button(action: {
                                alarmViewModel.setAlarm(at: index ,Alarm: Alarm(hour: hourSelection, min: minuteSelection, description: description, isAvailable: isAvailable))
                                self.presentationMode.wrappedValue.dismiss()
                            },label:{
                                CustomButtonLabel(txt: "Change alarm", color: Color(red: 28/255, green: 52/255, blue: 97/255))
                        })
                        Button(action: {
                                alarmViewModel.removeAlarm(at: index)
                                self.presentationMode.wrappedValue.dismiss()
                            },label:{
                                CustomButtonLabel(txt: "Delete", color: Color(red: 235/255, green: 77/255, blue: 61/255))
                        })
                    }
//                    .padding()
                }
                .navigationBarTitle(Text("Edit Alarm").font(.largeTitle),displayMode: .inline)
                .padding()
            }
        }
    }
}
