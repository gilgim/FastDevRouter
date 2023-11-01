//
//  WorkHistoryModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/11/01.
//

import Foundation
import CoreData

class WorkHistoryModel {
    let context = Persistent.shared.container.viewContext
    func read() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkOutExercise")
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [WorkOutExercise]
        } catch {
            print("Failed to fetch exercise: \(error)")
            return nil
        }
    }
    func delete(id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkOutExercise")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let result = try context.fetch(fetchRequest)
            let exercises = result as? [WorkOutExercise]
            if let exercise = exercises?.first {
                context.delete(exercise)
                Persistent.shared.saveContext()
            }
        } catch {
            print("Failed to fetch exercise: \(error)")
        }
    }
}
