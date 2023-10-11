//
//  WorkOutExerciseModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/28.
//

import Foundation
import CoreData

class WorkOutExerciseModel {
    let context = Persistent.shared.container.viewContext
    func recordWorkOut(workOutData: UserWorkOutExercise) throws {
        
        let fetchRequset = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequset.predicate = .init(format: "name == %@", workOutData.workOutExercise.name)
        
        guard let result = try? context.fetch(fetchRequset) else { throw ExerciseError.ReadError }
        guard let exercises = result as? [Exercise], exercises.count > 0 else { throw ExerciseError.ReadError}
        
        let exercise = exercises[0]
        let workOutExercise = WorkOutExercise(context: context)
        workOutExercise.id = workOutData.id
        workOutExercise.date = .now
        workOutExercise.exercise = exercise
        workOutExercise.totalDuration = Util.intToInt32(int: workOutData.totalDuration)
        
        for setData in workOutData.set {
            let set = ExerciseSet(context: context)
            set.setNumber = Util.intToInt16(int: setData.setNumber)
            set.weight = setData.weight
            set.unit = setData.unit
            set.reps = Util.intToInt16(int: setData.reps)
            set.exerciseDuration = Util.intToInt32(int: setData.exerciseDuration)
            set.restDuration = Util.intToInt32(int: setData.restDuration)
            workOutExercise.addToSets(set)
        }
        
        Persistent.shared.saveContext()
    }
    
    func read() -> [WorkOutExercise]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkOutExercise")
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [WorkOutExercise]
        } catch {
            print("Failed to fetch exercise: \(error)")
            return nil
        }
    }
}
