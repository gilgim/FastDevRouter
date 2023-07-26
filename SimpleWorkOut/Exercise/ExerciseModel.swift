//
//  ExerciseModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/26.
//

import Foundation
import CoreData

class ExerciseModel {
    let context = Persistent.shared.container.viewContext
    func create(name: String, type: String? = nil) throws {
        guard name != "" else { throw ExerciseError.CreateError }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        guard let result = try? context.fetch(fetchRequest) else { throw ExerciseError.ReadError}
        let exercises = result as? [Exercise]
        guard exercises?.count ?? 0 <= 0 else { throw ExerciseError.DuplicateError}
        
        let exercise = Exercise(context: context)
        exercise.id = .init()
        exercise.name = name
        exercise.type = type
        exercise.create_date = .now
        Persistent.shared.saveContext()
    }
    
    func read(key: String? = nil) -> [NSManagedObject]? {
        if let key {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
            fetchRequest.predicate = NSPredicate(format: "name == %@", key)
            do {
                let result = try context.fetch(fetchRequest)
                return result as? [Exercise]
            } catch {
                print("Failed to fetch exercise: \(error)")
                return nil
            }
        }
        else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
            do {
                let result = try context.fetch(fetchRequest)
                return result as? [Exercise]
            } catch {
                print("Failed to fetch exercise: \(error)")
                return nil
            }
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            let exercises = result as? [Exercise]
            if let exercise = exercises?.first {
                context.delete(exercise)
                Persistent.shared.saveContext()
            }
        } catch {
            print("Failed to fetch exercise: \(error)")
        }
    }
}
