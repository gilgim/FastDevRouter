//
//  AddRoutineViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/08/01.
//

import Foundation

class AddRoutineViewModel: ObservableObject {
    let model = AddRoutineModel()
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
}
