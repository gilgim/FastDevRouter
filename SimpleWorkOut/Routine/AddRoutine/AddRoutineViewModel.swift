//
//  AddRoutineViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import Foundation

class AddRoutineViewModel: ObservableObject {
    let model = AddRoutineModel()
    @Published public var error: RoutineError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    @Published var selectExercises: [WorkOutByExercise] = []
    @Published var allExercises: [WorkOutByExercise]
    init() {
        let exercises = model.read() as? [Exercise]
        if let exercises {
            allExercises = exercises.map({WorkOutByExercise(name: $0.name ?? "Not Found", type: $0.type ?? "Not Fount", set: 0, rest: 0)})
        }
        else {
            allExercises = []
        }
    }
    public func createRoutine(name: String, type: String? = nil, completion: @escaping () -> ()) {
        do {
            try model.create(name: name, type: type, exercises: self.selectExercises)
            completion()
        }
        catch {
            self.error = error as? RoutineError
        }
    }
    public func addExercise(exercise: WorkOutByExercise, setReps: String, restDuration: String) {
        guard let setReps = Int(setReps), let restDuration = Int(restDuration) else {error = .CreateError; return}
        var exercise = exercise
        exercise.id = UUID()
        exercise.set = setReps
        exercise.rest = restDuration*100
        selectExercises.append(exercise)
    }
}
