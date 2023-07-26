//
//  ExerciseViewModel.swift
//  SimpleWorkOut
//
//  Created by Gaea on 2023/07/26.
//

import Foundation

class ExerciseViewModel: ObservableObject {
    let model = ExerciseModel()
    @Published public var error: ExerciseError? = nil {
        didSet {
            if error != nil {
                isError = true
            }
        }
    }
    @Published public var isError: Bool = false
    @Published public var exercises: [(name: String, type: String)] = []
    
    public func createExercise(name: String, type: String? = nil) {
        do {
            try model.create(name: name, type: type)
            self.fetchExercises()
        }
        catch {
            self.error = error as? ExerciseError
        }
    }
    
    public func delectExercise(name: String) {
        model.delete(name: name)
        fetchExercises()
    }
    
    public func fetchExercises() {
        guard let list = model.read() else {return}
        exercises = list.map({
            if let exercise = $0 as? Exercise {
                 return (exercise.name ?? "", exercise.type ?? "")
            }
            else {
                return ("","")
            }
        })
    }
}
