//
//  ContentView.swift
//  Mid-term
//
//  Created by  Yeskendir Ayat on 22.10.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var alarmsViewModel = AlarmViewModel()
    @State var showingDetail = false
    var body: some View {
        VStack{
            NavigationView {
                List{
                    ForEach(alarmsViewModel.alarms.indexed(), id: \.1.id){ index, alarm in
                        NavigationLink(destination: EditAlarmView(alarmViewModel: self.alarmsViewModel, description: alarmsViewModel.alarms[index].description, hourSelection: alarmsViewModel.alarms[index].hour,minuteSelection: alarmsViewModel.alarms[index].min, index: index, isAvailable: alarmsViewModel.alarms[index].isAvailable)){
                            AlarmCell(alarmViewModel: self.alarmsViewModel, index: index,hour: alarmsViewModel.alarms[index].$hour, min: alarmsViewModel.alarms[index].$min, description: alarmsViewModel.alarms[index].$description, isAvailable: alarmsViewModel.alarms[index].$isAvailable, isOn: alarmsViewModel.alarms[index].isAvailable)
                        }
                    }.onDelete(perform: alarmsViewModel.removeAlarm)
                }
                .navigationBarTitle(Text("Alarms"))
                .navigationBarItems(trailing:
                HStack{
                    Button(action: {
                            self.showingDetail.toggle()
                        }){
                            Image(systemName: "plus").font(.title).foregroundColor(.blue)
                        }.sheet(isPresented: $showingDetail){
                            AddAlarmView(alarmViewModel: self.alarmsViewModel)
                        }
                }
            )}
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
