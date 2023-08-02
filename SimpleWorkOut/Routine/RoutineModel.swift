//
//  RoutineModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import Foundation
import CoreData

class RoutineModel {
    let context = Persistent.shared.container.viewContext
    func read(key: String? = nil) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [Routine]
        } catch {
            print("Failed to fetch routine: \(error)")
            return nil
        }
    }
    
    func update(name: String, type: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            let exercises = result as? [Exercise]
            let exercise = exercises?.first
            exercise?.name = name
            exercise?.type = type
            Persistent.shared.saveContext()
        } catch {
            print("Failed to fetch exercise: \(error)")
        }
    }
    
    func delete(name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            let routines = result as? [Routine]
            if let routine = routines?.first {
                context.delete(routine)
                Persistent.shared.saveContext()
            }
        } catch {
            print("Failed to fetch routine: \(error)")
        }
    }
}
