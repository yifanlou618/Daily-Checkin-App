//
//  IndexView.swift
//  DAKA
//
//  Created by HLi on 4/29/21.
//

import SwiftUI

struct IndexView: View {
    @Environment(\.managedObjectContext) private var viewContent
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @State private var task_count: Int = 0

    var body: some View {
        VStack {
            HStack {
                Text("\(getDate())").font(.system(size: 56.0))
            }
            Text("You have \(task_count) tasks to do")
            List {
                ForEach(0..<tasks.count,id:\.self) { idx in
                    HStack(alignment: .center) {
                        // retrieve name from coredata
                        Text(tasks[idx].name!)
                        // delete goal from CoreData when user click on goal tab
                        Button(action: {
                                let day = UserDefaults.standard.integer(forKey: tasks[idx].id!.uuidString) + 1
                                UserDefaults.standard.set(day, forKey: tasks[idx].id!.uuidString)
                                deleteTask(task: tasks[idx]);
                                task_count -= 1}) {
                            Image(systemName: "checkmark")
                        }
                        .frame(alignment: .trailing)
                    }
                }
            }
            ZStack {
                Image("tree")
                    .resizable()
                    .scaledToFit()
                    //.scaleEffect(0.5)
                    .offset(y: 11)
                ZStack {
                    Rectangle()
                        .frame(width: 414, height: 1)
                        .offset(y: 187)
                    Rectangle()
                        .frame(width: 25, height: 30)
                        .foregroundColor(Color(red: 0.249, green: 0.241, blue: 0.337))
                        .offset(x: 75, y: 27)
                }
                ZStack {
                    Image("leg_left")
                        .scaleEffect(0.4)
                        .offset(x: 92, y: 121)
                    Image("leg_right")
                        .scaleEffect(0.4)
                        .offset(x: 100, y: 121)
                    Image("lady_on_swing")
                        .scaleEffect(0.34)
                        .offset(x: 81, y: 71)
                }
                Image("flower_left_right")
                    .scaleEffect(0.6)
                    .offset(x: -51.5, y: 119)
                Image("flower_left_left")
                    .scaleEffect(0.6)
                    .offset(x: -60, y: 124)
                Image("flower_middle_right")
                    .scaleEffect(0.6)
                    .offset(x: 50, y: 122)
                Image("flower_middle_left")
                    .scaleEffect(0.6)
                    .offset(x: 41, y: 119)
                Image("flower_right_right")
                    .scaleEffect(0.6)
                    .offset(x: 150, y: 122)
                Image("flower_right_left")
                    .scaleEffect(0.6)
                    .offset(x: 140, y: 120)
            }
            .opacity(0.9)
            .scaleEffect(1.1)
            .offset(y: -25)
        }.onAppear() {
            /* update goal counter at render */
            task_count = tasks.count
            
            /* update Task from Goal */
            // Compare the dates
            let curr_date: String = getDate()
            let prev_date: String = UserDefaults.standard.object(forKey: "Date") as? String ?? ""
            // check date at launch time
            if prev_date == "" { // No Date key in userdefaults
                // Add date to userdefaults
                UserDefaults.standard.set(curr_date, forKey: "Date")
            } else {
                // Compare 2 dates
                if prev_date != curr_date{
                    // clear all left over in task
                    for task in tasks { deleteTask(task: task) }
                    // copying all goals to tasks
                    for goal in goals {
                        let newTask = Task(context: viewContent)
                        newTask.name = goal.name
                        newTask.type = goal.type
                        newTask.isLongTerm = goal.isLongTerm
                        newTask.progress = goal.progress
                        do {
                            try viewContent.save()
                        } catch {
                            fatalError("Failed to save file: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    // deleting a Goal object in CoreData
    public func deleteTask(task: Task) {
        withAnimation {
            // delete object
            viewContent.delete(task)
            // saving the changes in CoreData
            do {
                try viewContent.save()
            } catch {
                fatalError("Failed to save file: \(error.localizedDescription)")
            }
        }
    }
}

// Datetime transform function
public func getDate() -> String {
    let time = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
    let stringDate = timeFormatter.string(from: time)
    return stringDate
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
