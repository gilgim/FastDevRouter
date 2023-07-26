//
//  Persistant.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/25.
//

import Foundation
import CoreData

struct Persistent {
    static let shared = Persistent()
    static let preview = Persistent(inMemory: true)
    
    let container: NSPersistentContainer
    init(inMemory: Bool = false) {
        container = .init(name: "WorkOutDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("\(error)")
            }
        }
    }
    func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
