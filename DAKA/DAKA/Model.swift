//
//  Model.swift
//  DAKA
//
//  Created by Zhiyue Gao on 4/1/21.
//

import Foundation
import CoreData

class Model: ObservableObject {
    @Published var goals: [Goal]
    @Published var board: [Goal]
    @Published var size: Int
    
    init() {
        board = []
        goals = []
        size = 0
    }
    
    public func addGoal(task: Goal) {
        goals.append(task)
        board.append(task)
        size += 1
    }

    public func checkGoal(task: Goal) {
        for i in 0..<board.count {
            if (board[i].id == task.id) {
                board.remove(at: i)
            }
        }
        for i in 0..<goals.count {
            if (goals[i].id == task.id) {
                let p: Progresses = Progresses(date: getDate(), note: "")
                goals[i].progress!.append(p)
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
}
