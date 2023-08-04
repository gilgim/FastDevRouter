//
//  AddRoutineModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import Foundation
import CoreData

class AddRoutineModel {
    let context = Persistent.shared.container.viewContext
    func create(name: String, type: String? = nil, exercises: [WorkOutByExercise]) throws {
        guard name != "" else { throw RoutineError.EmptyCreateError }
        guard !exercises.isEmpty else { throw RoutineError.EmptyCreateError }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        guard let result = try? context.fetch(fetchRequest) else { throw RoutineError.ReadError}
        let routines = result as? [Exercise]
        guard routines?.count ?? 0 <= 0 else { throw RoutineError.DuplicateError}
        
        let routine = Routine(context: context)
        routine.id = .init()
        routine.name = name
        routine.type = type
        routine.create_date = .now
        
        for exercise in exercises {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
            fetchRequest.predicate = NSPredicate(format: "name == %@", exercise.name)
            guard let exercises = try? context.fetch(fetchRequest) as? [Exercise], exercises.count > 0 else {throw RoutineError.ReadExerciseError}
            
            let routineExercise = RoutineExercise(context: context)
            routineExercise.id = .init()
            routineExercise.exercise = exercises[0]
            routineExercise.restDuration = Util.intToInt32(int: exercise.rest)
            routineExercise.setReps = Util.intToInt16(int: exercise.set)
            
            routine.addToRoutineExercise(routineExercise)
        }
        Persistent.shared.saveContext()
    }
    
    func read(key: String? = nil) -> [NSManagedObject]? {
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
