//
//  Models.swift
//  Mid-term
//
//  Created by  Yeskendir Ayat on 21.10.2021.
//

import UIKit
import SwiftUI

class Alarm: Identifiable, ObservableObject {
    var id = UUID()
    @State var hour:String
    @State var min:String
    @State var description:String
    @State var isAvailable:Bool
    init(hour: String, min:String, description:String, isAvailable:Bool) {
        self.hour = hour
        self.min = min
        self.description = description
        self.isAvailable = isAvailable
    }
}
final class AlarmViewModel: ObservableObject{
    @Published var alarms:[Alarm] = [
        .init(hour: "09", min: "00", description: "IOS Advanced", isAvailable: true),
        .init(hour: "10", min: "15", description: "Mid-term", isAvailable: false),
        .init(hour: "13", min: "45", description: "Lunch", isAvailable: true)
    ]
    func addAlarm(Alarm newAlarm: Alarm){
        alarms.append(newAlarm)
    }
    func removeAlarm(at indexSet:IndexSet){
        self.alarms.remove(atOffsets: indexSet)
    }
    func removeAlarm(at index:Int){
        self.alarms.remove(at: index)
    }
    func setAlarm(at index: Int ,Alarm newAlarm: Alarm){
        alarms[index] = newAlarm
    }
}
class TimeList{
    var hoursList:[String] = []
    var minList:[String] = []
    init(){
        for i in 0..<24{
            if i<10{
                hoursList.append("0" + String(i))
                minList.append("0" + String(i))
            }
            else{
                hoursList.append(String(i))
            }
        }
        for i in 23..<60{
            minList.append(String(i))
        }
    }
}
