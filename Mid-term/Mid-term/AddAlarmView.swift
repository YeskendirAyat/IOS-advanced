//
//  AddAlarmView.swift
//  Mid-term
//
//  Created by  Yeskendir Ayat on 22.10.2021.
//

import Foundation
import SwiftUI
struct AddAlarmView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var alarmViewModel:AlarmViewModel
    @State var description:String = ""
    @State var hourSelection = "00"
    @State var minuteSelection = "00"
    var body: some View {
        GeometryReader { geometry in
            if #available(iOS 15.0, *) {
                NavigationView{
                    VStack(spacing:5){
                        Spacer()
                        VStack{
                            PickerView(geometry: geometry, hourSelection: $hourSelection, minuteSelection:$minuteSelection)
                                .pickerStyle(.wheel)
                                .cornerRadius(10.0)
                            CustomTextField(textField: TextField("Description", text: $description), imageName: "clock")
                        }
                        Spacer()
                        Button(action: {
                            alarmViewModel.addAlarm(Alarm: Alarm(hour: String(hourSelection), min: String(minuteSelection), description: description, isAvailable: true))
                            self.presentationMode.wrappedValue.dismiss()
                        },label:{
                            CustomButtonLabel(txt: "Save", color: Color(red: 28/255, green: 52/255, blue: 97/255))
                        })
                    }
                    .navigationBarTitle(Text("Add Alarm"), displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel").bold()
                        })
                    
                }.interactiveDismissDisabled()
                    .padding()
            }
        }
    }
}
