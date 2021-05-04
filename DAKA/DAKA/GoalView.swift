//
//  GoalView.swift
//  DAKA
//
//  Created by HLi on 4/29/21.
//

import SwiftUI

struct GoalView: View {
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @FetchRequest(sortDescriptors: []) var tasks: FetchedResults<Task>
    @State var task_idx: Int = 0
    
    private func getIdx() -> Int {
        var idx: Int = 0
        for i in 0..<goals.count {
            for j in 0..<tasks.count {
                if (goals[i].id == tasks[j].id) {
                    idx = j
                    break;
                }
            }
        }
        return idx
    }
    var body: some View {
        VStack {
            List {
                ForEach(0..<goals.count,id:\.self) { idx in
                    NavigationLink(
                        destination: EditView(goal_idx: idx, task_idx: $task_idx, goal_name: goals[idx].name!, goal_type: goals[idx].type!, isLongTerm: goals[idx].isLongTerm, notification: goals[idx].notification, startDate: goals[idx].sDate!, endDate: goals[idx].eDate!, time: goals[idx].time!, id: goals[idx].id!),
                        label: { Text(goals[idx].name!) }
                    )
                }
            }
        }.navigationTitle("Your Goals")
        .onAppear() {
            task_idx = getIdx()
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
