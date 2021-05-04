//
//  AddView.swift
//  DAKA
//
//  Created by HLi on 4/29/21.
//

import SwiftUI
import CoreData

struct AddView: View {
    @Environment(\.managedObjectContext) private var viewContent
    @Environment(\.presentationMode) private var presentationMode
    
    var types = ["Study", "Workout", "Hobby", "Habbit", "Other", "None"]
    @State private var showAlert = false
    @State var isLongTerm: Bool = false
    @State var notification: Bool = false
    @State var taskName: String = ""
    @State var taskType: String = "<Select>"
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var time: Date = Date()
    //    @State var progress: [Progress] = []
    
    var body: some View {
        VStack {
            Form {
                // name section
                Section(header: Text("GOAL NAME")) {
                    Text("Name For Your Goal:")
                    TextField("Name", text: $taskName)
                }
                // type section
                Section(header: Text("GOAL TYPE")) {
                    // getting goal type
                    Text("Type For Your Goal:")
                    Picker("\(taskType)", selection: $taskType) {
                        ForEach(types, id: \.self){ Text($0) }
                    }.pickerStyle(MenuPickerStyle())
                }
                Section(header: Text("GOAL DATE")) {
                    Toggle(isOn: $isLongTerm) {
                        Text("Long Term Goal? (No end date)")
                    }
                    // Start & End date
                    DatePicker("Start time for the goal:", selection: $startDate, displayedComponents: .date)
                    DatePicker("End time for the goal:", selection: $endDate, displayedComponents: .date)
                }
                Section(header: Text("Notification")) {
                    Toggle(isOn: $notification) {
                        Text("Notify me")
                    }
                    DatePicker("Everyday at", selection: $time, displayedComponents: .hourAndMinute)
                }
            }
            // submit button
            Button("Create my Goal") {
                // Input validation (Must have a goal name)
                if taskName == "" {
                    showAlert.toggle()
                } else {
                    // Adding goal to CoreData
                    addTask(name: taskName, type: taskType, isLongTerm: isLongTerm, progress: [], ntf: notification, t:time, sd: startDate, ed: endDate)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(NeumorphicButtonStyle())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Your Goal Need a Name"),
                      message: Text("Please give your goal a valid name."),
                      dismissButton: .default(Text("Got it!")))
            }
            .padding()
        }
        .navigationTitle("Creat Your Goal")
    }
    
    // adding Task to coredata
    public func addTask(name: String, type: String, isLongTerm: Bool, progress: [Progresses], ntf: Bool, t: Date, sd: Date, ed: Date) {
        let newTask = Task(context: viewContent)
        let newGoal = Goal(context: viewContent)
        newTask.name = name
        newTask.type = type
        newTask.isLongTerm = isLongTerm
        newTask.progress = progress
        // saving the changes in CoreData
        newGoal.name = name
        newGoal.type = type
        newGoal.isLongTerm = isLongTerm
        newGoal.progress = progress
        newGoal.sDate = sd
        newGoal.eDate = ed
        newGoal.time = t
        newGoal.notification = ntf
        if ntf {
            let id = addNotification(Content: name, t: t)
            newGoal.id = id
            newTask.id = id
            UserDefaults.standard.set(0, forKey: id.uuidString)
        } else {
            let id = UUID()
            newGoal.id = id
            newTask.id = id
            UserDefaults.standard.set(0, forKey: id.uuidString)
        }
        do {
            try viewContent.save()
        } catch {
            fatalError("Failed to save file: \(error.localizedDescription)")
        }
    }
    
    public func addNotification(Content: String, t: Date)-> UUID{
        let content = UNMutableNotificationContent()
        content.title = "DAKA: come and check your today's goal"
        content.subtitle = "You have Goal \(taskName) to do today, keep it up!"
        content.sound = UNNotificationSound.default
        let comps = Calendar.current.dateComponents([.hour, .minute], from: t)
        let uid = UUID()
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: uid.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        return uid
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
