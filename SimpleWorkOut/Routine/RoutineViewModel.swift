//
//  RoutineViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import Foundation

class RoutineViewModel: ObservableObject {
    @Published var routines: [(name: String, type: String?, exercises: [WorkOutByExercise])] = []
    let model = RoutineModel()
    public func delectRoutine(name: String) {
        model.delete(name: name)
        fetchRoutines()
    }
    public func fetchRoutines() {
        guard let list = model.read() as? [Routine] else {return}
        routines = list.map({
            guard let exercises = $0.routineExercise?.allObjects as? [RoutineExercise] else {return ("",nil,[])}
            
            var exerciseStorage: [WorkOutByExercise] = []
            for exercise in exercises {
                let workOutByExercise = WorkOutByExercise(id: .init(), name: exercise.exercise?.name ?? "", type: exercise.exercise?.type ?? "", set: Int(exercise.setReps), rest: Int(exercise.restDuration))
                exerciseStorage.append(workOutByExercise)
            }
            
            return ($0.name ?? "", $0.type, exerciseStorage)
        })
    }
}
