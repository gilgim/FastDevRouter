//
//  WorkOutRoutineModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/03.
//

import Foundation
import CoreData

class WorkOutRoutineModel {
    let context = Persistent.shared.container.viewContext
    private var workOutRoutine: WorkOutRoutine? = nil
    private var completeExercises: [UserWorkOutExercise] = []
    public func createWorkOutRoutine(selectRoutine: UserWorkOutRoutine) throws {
        if workOutRoutine == nil {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routine")
            fetchRequest.predicate = .init(format: "name == %@", selectRoutine.workOutRoutine.name)
            guard let result = try? context.fetch(fetchRequest),
                  let routines = result as? [Routine], routines.count > 0 else { throw WorkOutRoutineError.ReadError }
            workOutRoutine = WorkOutRoutine(context: context)
            workOutRoutine?.id = selectRoutine.id
            workOutRoutine?.routine = routines[0]
            workOutRoutine?.date = .now
        }
    }
    
    public func getNotCompleteExercises() throws -> [RoutineExercise] {
        let allExerciseList = self.workOutRoutine?.routine?.routineExercise?.allObjects as? [RoutineExercise] ?? []
        let notCompleteExerciseList = allExerciseList.filter({ value in
            return !completeExercises.contains(where: {$0.id == value.id})
        })
        return notCompleteExerciseList
    }
    
    public func getCompleteExercise() -> [UserWorkOutExercise] {
        return completeExercises
    }
    public func recordRoutine() throws {
        for completeExercise in completeExercises {
            let fetchRequset = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
            fetchRequset.predicate = .init(format: "name == %@", completeExercise.workOutExercise.name)
            
            guard let result = try? context.fetch(fetchRequset),
                  let exercises = result as? [Exercise], exercises.count > 0 else { throw WorkOutRoutineError.ReadError }
            
            let exercise = exercises[0]
            let workOutExercise = WorkOutExercise(context: context)
            workOutExercise.id = .init()
            workOutExercise.date = .now
            workOutExercise.exercise = exercise
            
            for setData in completeExercise.set {
                let set = ExerciseSet(context: context)
                set.setNumber = Util.intToInt16(int: setData.setNumber)
                set.weight = setData.weight
                set.reps = Util.intToInt16(int: setData.reps)
                set.exerciseDuration = Util.intToInt32(int: setData.exerciseDuration)
                set.restDuration = Util.intToInt32(int: setData.restDuration)
                
                workOutExercise.addToSets(set)
            }
            workOutRoutine?.addToWorkOutExercise(workOutExercise)
        }
        Persistent.shared.saveContext()
    }
    public func addCompleteExercise(completeExercise: UserWorkOutExercise) {
        completeExercises.append(completeExercise)
    }
}

