//
//  CoreDataManager.swift
//  DAKA
//
//  Created by HLi on 4/29/21.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unable to solve: \(error.localizedDescription)")
            }
        }
    }
}
