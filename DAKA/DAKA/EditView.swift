//
//  SettingView.swift
//  DAKA
//
//  Created by HLi on 4/30/21.
//

import SwiftUI
import CoreData

struct EditView: View {
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    @Environment(\.managedObjectContext) private var viewContent
    @Environment(\.presentationMode) private var presentationMode
    
    let goal_idx: Int // index for current goal in coredata
    @Binding var task_idx: Int
    @State var goal_name: String
    @State var goal_type: String
    @State var isLongTerm: Bool
    @State var notification: Bool
    @State var startDate: Date
    @State var endDate: Date
    @State var time: Date
    @State var id: UUID
    var types = ["Study", "Workout", "Hobby", "Habbit", "Other", "None"]
    @State private var showAlert = false
    @State private var showDeleteAlert = false
    //    @State var progress: [Progress] = []
    
    var body: some View {
        VStack {
            Form {
                Text("You have completed this goal \(UserDefaults.standard.integer(forKey: id.uuidString)) days")
                // name section
                Section(header: Text("GOAL NAME")) {
                    Text("Name For Your Goal:")
                    TextField("Name", text: $goal_name)
                }
                // type section
                Section(header: Text("GOAL TYPE")) {
                    // getting goal type
                    Text("Type For Your Goal:")
                    Picker("\(goal_type)", selection: $goal_type) {
                        ForEach(types, id: \.self){ Text($0) }
                    }.pickerStyle(MenuPickerStyle())
                }
                Section(header: Text("GOAL DATE")) {
                    Toggle(isOn: $isLongTerm) { Text("Long Term Goal? (No end date)") }
                    // Start & End date
                    DatePicker("Start time for the goal:", selection: $startDate, displayedComponents: .date)
                    DatePicker("End time for the goal:", selection: $endDate, displayedComponents: .date)
                }
                Section(header: Text("Notification")) {
                    Toggle(isOn: $notification) { Text("Notify me") }
                    DatePicker("Everyday at", selection: $time, displayedComponents: .hourAndMinute)
                }
            }
            HStack {
                // submit button
                Button("Save Change") {
                    // Input validation (Must have a goal name)
                    if goal_name == "" { showAlert.toggle() } else {
                        // editing goal to CoreData
                        editGoal(name: goal_name, type: goal_type, isLongTerm: isLongTerm, progress: [])
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
                Button(action: { showDeleteAlert.toggle()
                                if tasks.count != 0 {
                                    deleteGoal(goal: goals[goal_idx],task:tasks[task_idx])
                                } else {
                                    deleteJustGoal(goal: goals[goal_idx])
                                }
                                presentationMode.wrappedValue.dismiss()}) {
                HStack {
                    Image(systemName: "trash").font(.title3)
                    Text("Delete").bold().font(.title3)
                }
            }
            .buttonStyle(AlertButtonStyle())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Delete this goal?"),
                      message: Text("This will delete current goal selected."),
                      dismissButton: .default(Text("Delete")))}
            .padding()
            }
        }.navigationTitle("Edit Your Goal")
    }
    // editing goal to coredata
    func editGoal(name: String, type: String, isLongTerm: Bool, progress: [Progresses]) {
        goals[goal_idx].name = name
        goals[goal_idx].type = type
        if notification {
            let id = addNotification(c: name, t: time)
            goals[goal_idx].id = id
        } else {
            // disable the notification
            var identifiers: [String] = []
            identifiers.append(goals[goal_idx].id?.uuidString ?? "")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        do {
            try viewContent.save()
        } catch {
            fatalError("Failed to save file: \(error.localizedDescription)")
        }
    }

    func deleteGoal(goal: Goal, task: Task) {
        withAnimation {
            // disable the notification
            var identifiers: [String] = []
            identifiers.append(goal.id?.uuidString ?? "")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            viewContent.delete(task)
            viewContent.delete(goal)
            // saving the changes in CoreData
            do {
                try viewContent.save()
            } catch {
                fatalError("Failed to save file: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteJustGoal(goal: Goal) {
        withAnimation {
            // disable the notification
            var identifiers: [String] = []
            identifiers.append(goal.id?.uuidString ?? "")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            viewContent.delete(goal)
            // saving the changes in CoreData
            do {
                try viewContent.save()
            } catch {
                fatalError("Failed to save file: \(error.localizedDescription)")
            }
        }
    }
//
    public func addNotification(c: String, t: Date)-> UUID{
        let content = UNMutableNotificationContent()
        content.title = "DAKA: come and check your today's goal"
        content.subtitle = "You have Goal \(c) to do today, keep it up!"
        content.sound = UNNotificationSound.default
        let comps = Calendar.current.dateComponents([.hour, .minute], from: t)
        let uid = UUID()
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(identifier: uid.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        return uid
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
