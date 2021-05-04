//
//  Progresses.swift
//  DAKA
//
//  Created by Yifan Michael Lou on 5/1/21.
//

import Foundation

// This is the type for each days goal accomplishment
public class Progresses: NSObject, NSCoding {
    var id = UUID () // identifiable ID
    var date: String // The date that accomplished the goal
    var note: String // Any Custom Note that users leave
    
    init(date: String, note: String) {
        self.date = date
        self.note = note
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.date, forKey: "date")
        coder.encode(self.note, forKey: "note")
    }
    
    public required convenience init?(coder: NSCoder) {
        let temp_date = coder.decodeObject(forKey: "date") as! String
        let temp_note = coder.decodeObject(forKey: "note") as! String
        
        self.init(date:temp_date, note:temp_note)
    }
}
