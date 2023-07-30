//
//  WorkOutSaveModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/28.
//

import Foundation
import CoreData

class WorkOutSaveModel {
    let context = Persistent.shared.container.viewContext
    func recordWorkOut(workOutData: UserWorkOut) throws {
        
        let fetchRequset = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequset.predicate = .init(format: "nmae == %@", workOutData.workOutExercise.name)
        
        guard let result = try? context.fetch(fetchRequset) else { throw ExerciseError.ReadError }
        guard let exercises = result as? [Exercise], exercises.count > 0 else { throw ExerciseError.ReadError}
        
        let exercise = exercises[0]
        let workOutExercise = WorkOutExercise(context: context)
        workOutExercise.date = .now
        workOutExercise.exercise = exercise
        
        for setData in workOutData.set {
            let set = Set(context: context)
            if setData.reps <= Int(Int16.max) && setData.reps >= Int(Int16.min) {
                set.reps = Int16(setData.reps)
            } else {
                print("Cannot convert, value is out of range for Int16")
                set.reps = Int16.max
            }
            set.weight = setData.weight
            workOutExercise.addToSets(set)
        }
        
        Persistent.shared.saveContext()
    }
}
